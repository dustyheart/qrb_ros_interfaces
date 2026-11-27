# Runtime state / fault report of one stream (added in 3.0.0).
# Published by the audio service on the node-relative topic
# "audio_stream_status" (all streams share it; filter by stream_handle):
# on every event below, plus a periodic heartbeat (event = EVENT_HEARTBEAT)
# while the stream is running.

# ---- state ----
uint8 STATE_UNKNOWN = 0
uint8 STATE_CREATED = 1   # created, not started (or stopped and restartable)
uint8 STATE_STARTING = 2  # start accepted, waiting for the first data
uint8 STATE_RUNNING = 3   # data flowing
uint8 STATE_ERROR = 4     # failed; see error_code. Client should stop/release
uint8 STATE_RELEASED = 5  # last message for this stream_handle

# ---- event: why this message was published ----
uint8 EVENT_HEARTBEAT = 0         # periodic, nothing changed
uint8 EVENT_STATE_CHANGED = 1     # state changed by a client command
uint8 EVENT_START_TIMEOUT = 2     # started but no data within the start timeout
                                  # (e.g. ALSA snd_pcm_start timed out)
uint8 EVENT_DATA_RESUMED = 3      # first data after EVENT_START_TIMEOUT / EVENT_DEVICE_LOST
uint8 EVENT_DEVICE_LOST = 4       # device removed or backend connection lost
uint8 EVENT_DEVICE_RECOVERED = 5  # device back and stream reconnected
uint8 EVENT_OVERRUN = 6           # capture audio dropped (see dropped_frames)
uint8 EVENT_UNDERRUN = 7          # playback starved
uint8 EVENT_PROCESSOR_FAILED = 8  # a capture processor failed; chain now bypassed

# header.stamp: time of the event on the publishing node's ROS clock (always
#  set). header.frame_id: same as the stream's AudioData.header.frame_id.
std_msgs/Header header
# The handle of the stream (AudioRequest.stream_handle).
uint32 stream_handle
# "record" or "playback" (AudioRequest.type).
string type
# One of STATE_*.
uint8 state
# One of EVENT_*. Receivers must treat unknown values like EVENT_STATE_CHANGED.
uint8 event
# Same vocabulary as AudioRequest error_code (e.g. "device_unavailable",
# "backend_init_failed"); empty unless the event / state is a fault.
string error_code
# Human-readable detail; not stable across versions, do not parse.
string error_message
# Backend device name actually in use.
string device
# Counters since the last start; reset on start.
uint64 frames_transferred   # sample frames captured / played
uint64 dropped_frames       # capture sample frames lost (overruns, queue overflow)
uint32 xrun_count           # overrun + underrun occurrences
