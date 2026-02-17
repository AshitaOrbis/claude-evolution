# YouTube Transcriber Skill

> Transcribe YouTube videos using Gemini via MCP

## Overview

This skill transcribes YouTube videos by:
1. Downloading audio with yt-dlp
2. Converting to 16kHz mono WAV with ffmpeg
3. Chunking long audio into 10-minute segments
4. Transcribing each chunk with Gemini 2.5 Pro via `mcp__gemini-cli__ask-gemini`
5. Merging chunks into a final JSON transcript with timestamps
6. **Identifying speakers** using video metadata (title, channel, description)

## Usage

Invoke this skill when transcribing YouTube videos:
```
/youtube-transcriber <URL>
```

Or describe the task:
```
"Transcribe this YouTube video: https://youtube.com/watch?v=VIDEO_ID"
```

## Workflow

### Step 1: Setup Run Directory

```bash
VIDEO_ID=$(echo "$URL" | grep -oP '(?<=v=)[^&]+')
RUN_DIR="~/your-project/youtube-transcriber/runs/$VIDEO_ID"
mkdir -p "$RUN_DIR/audio/chunks"
```

### Step 2: Download Audio

```bash
cd ~/your-project/youtube-transcriber
./scripts/download.sh "$URL" "$RUN_DIR/audio"
```

### Step 3: Convert to WAV

```bash
INPUT=$(ls "$RUN_DIR/audio"/*.m4a 2>/dev/null | head -1)
./scripts/convert.sh "$INPUT" "$RUN_DIR/audio/audio.wav"
```

### Step 4: Check Duration and Chunk if Needed

```bash
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$RUN_DIR/audio/audio.wav")

# If longer than 10 minutes, chunk it
if (( $(echo "$DURATION > 600" | bc -l) )); then
    ./scripts/chunk.sh "$RUN_DIR/audio/audio.wav" "$RUN_DIR/audio/chunks" 600
fi
```

### Step 5: Transcribe with Gemini 2.5 Pro

For each audio chunk (or single file if short), use the Gemini MCP:

```
mcp__gemini-cli__ask-gemini
  model: gemini-2.5-pro
  prompt: |
    @/path/to/chunk.wav

    Transcribe this audio segment with timestamps and speaker diarization.
    Return ONLY valid JSON in this exact format:
    {"segments": [{"start": 0.0, "end": 5.2, "text": "transcribed text here", "speaker": "Speaker 1"}]}
```

**Note**: Use `gemini-2.5-pro` - the `gemini-3-pro-preview` model does not reliably transcribe audio files.

### Step 6: Merge Transcripts

Combine all chunk transcripts, adjusting timestamps:
- chunk_000: timestamps as-is (offset 0)
- chunk_001: add 600 seconds to all timestamps
- chunk_002: add 1200 seconds to all timestamps
- etc.

### Step 7: Identify Speakers from Context

Replace generic "Speaker 1", "Speaker 2" labels with actual names using available context:

**Context Sources (in order of reliability)**:
1. **Video title** - Often contains guest name (e.g., "John Doe Interview")
2. **Channel name** - Usually the host/interviewer
3. **Video description** - May list participants
4. **info.json** - Contains all YouTube metadata

**Identification Strategy**:
```python
# From video metadata
title = "John Doe Interview"  # Guest in title
channel = "Tech Talks"  # Host is channel owner

# Conversation analysis
# - Interviewer: Asks questions, shorter segments
# - Guest: Gives detailed answers, longer segments

# Map speakers
speaker_map = {
    "Speaker 1": "John",    # Guest giving long technical answers
    "Speaker 2": "Host" # Host asking questions
}

# Update all segments
for segment in segments:
    segment["speaker"] = speaker_map.get(segment["speaker"], segment["speaker"])
```

**Heuristics for Interview/Podcast Format**:
| Pattern | Likely Role |
|---------|-------------|
| Longer, technical responses | Guest/Expert |
| Short questions, follow-ups | Host/Interviewer |
| First speaker after intro | Usually host |
| Name in video title | Guest |
| Channel owner name | Host |

### Step 8: Save Final JSON

Save to `$RUN_DIR/transcript.json` with structure:
```json
{
  "video_id": "VIDEO_ID",
  "title": "Video Title",
  "duration": 1234.56,
  "transcribed_at": "2025-12-31T12:00:00Z",
  "model": "gemini-2.5-pro",
  "segments": [...],
  "metadata": {
    "speakers": {
      "John": "John Doe - Guest",
      "Host": "Tech Talks Host"
    },
    "speaker_identification_method": "Derived from video title and channel name"
  }
}
```

## Key Settings

| Setting | Value | Reason |
|---------|-------|--------|
| Model | `gemini-2.5-pro` | Reliable audio transcription (3-pro-preview doesn't work) |
| Audio format | 16kHz mono WAV | Optimal for speech recognition |
| Chunk duration | 600 seconds (10 min) | Balance between context and API limits |
| Output format | JSON with segments | Structured for downstream processing |
| Speaker ID | From video metadata | Use title/channel for real names |

## Helper Scripts

Located in `~/your-project/youtube-transcriber/scripts/`:

| Script | Purpose |
|--------|---------|
| `download.sh` | Download audio from YouTube URL |
| `convert.sh` | Convert audio to 16kHz mono WAV |
| `chunk.sh` | Split audio into segments |

## Output Format

```json
{
  "video_id": "abc123",
  "title": "Example Interview",
  "channel": "Tech Talks",
  "duration_seconds": 3600.0,
  "transcript": {
    "segments": [
      {
        "start": 0.0,
        "end": 5.2,
        "text": "Hello and welcome...",
        "speaker": "Host"
      },
      {
        "start": 5.2,
        "end": 45.8,
        "text": "Thanks for having me...",
        "speaker": "John"
      }
    ],
    "full_text": "Hello and welcome... Thanks for having me..."
  },
  "metadata": {
    "model": "gemini-2.5-pro",
    "speakers": {
      "John": "John Doe - Guest",
      "Host": "Tech Talks Host"
    },
    "speaker_identification_method": "Derived from video title and channel name",
    "processed_at": "2025-12-31T12:00:00Z"
  }
}
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| yt-dlp fails | Update: `pip install -U yt-dlp` |
| Audio too long | Chunking handles this automatically |
| Gemini timeout | Reduce chunk size or retry |
| Speaker confusion | Post-process to merge similar speakers |
| Speaker IDs inconsistent across chunks | Gemini assigns Speaker 1/2 per chunk independently - may need cross-chunk alignment |

### Speaker ID Limitations

When chunking long videos, Gemini assigns "Speaker 1" and "Speaker 2" based on who speaks first **in each chunk**. This means:
- Speaker 1 in chunk_000 might be the host
- Speaker 1 in chunk_005 might be the guest (if guest speaks first in that chunk)

**Workarounds**:
1. Use voice similarity/embedding to align speakers across chunks
2. Use LLM to analyze content and reassign (questions vs answers)
3. Manual review for critical transcripts

## Dependencies

- `yt-dlp` - YouTube audio download
- `ffmpeg` - Audio conversion and chunking
- `mcp__gemini-cli__ask-gemini` - Gemini MCP for transcription
