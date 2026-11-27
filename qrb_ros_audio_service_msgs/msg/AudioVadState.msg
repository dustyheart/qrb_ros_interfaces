# Voice activity decision of a record stream (added in 3.0.0).
# Published by the audio service on "<AudioRequest.topic_name><vad_topic_suffix>"
# (default suffix "_vad") once per AudioData chunk, while a "vad" processor is
# active in the stream's capture chain. Replaces the interim std_msgs/Bool.

# Same header as the AudioData chunk this decision covers (stamp = capture
# time of its first sample, all zero without AudioRequest.need_timestamp), so
# message_filters ExactTime can pair the two topics.
std_msgs/Header header
# The handle of the stream this decision belongs to (AudioRequest.stream_handle).
uint32 stream_handle
# AudioData.sequence of the chunk this decision covers; pairs the two topics
# even when timestamps are disabled.
uint64 sequence
# true: speech detected in this chunk (after hangover smoothing,
# see the vad_hangover_ms parameter).
bool is_speech
