--- renderer/resources/CinematicFFMpeg.cpp.orig	2026-11-24 11:13:32 UTC
+++ renderer/resources/CinematicFFMpeg.cpp
@@ -306,11 +306,19 @@ bool idCinematicFFMpeg::_OpenDecoder() {
 	if (_withAudio) {
 		TIMER_START(createSwrCtx);
 		// Set up the scaling context used to convert the images to RGBA
-		_swResampleContext = ExtLibs::swr_alloc_set_opts(NULL,
-			(_channels == 2 ? AV_CH_LAYOUT_STEREO : AV_CH_LAYOUT_MONO), AV_SAMPLE_FMT_FLT, FREQ44K,
-			_audioDecoderContext->channel_layout, _audioDecoderContext->sample_fmt, _audioDecoderContext->sample_rate,
-			0, _customIOContext
-		);
+		{
+			AVChannelLayout out_ch_layout = (_channels == 2) ? (AVChannelLayout)AV_CHANNEL_LAYOUT_STEREO
+			                                                : (AVChannelLayout)AV_CHANNEL_LAYOUT_MONO;
+			AVChannelLayout in_ch_layout  = _audioDecoderContext->ch_layout;
+			int ret = ExtLibs::swr_alloc_set_opts2(&_swResampleContext,
+				&out_ch_layout, AV_SAMPLE_FMT_FLT, FREQ44K,
+				&in_ch_layout,  _audioDecoderContext->sample_fmt, _audioDecoderContext->sample_rate,
+				0, _customIOContext);
+			if (ret < 0) {
+				common->Warning("Could not allocate audio resample context for %s\n", _path.c_str());
+				return false;
+			}
+		}
 		ExtLibs::swr_init(_swResampleContext);
 		if (!ExtLibs::swr_is_initialized(_swResampleContext)) {
 			common->Warning("Could not initialize audio resample context for %s\n", _path.c_str());
@@ -597,7 +605,7 @@ void idCinematicFFMpeg::ProcessDecodedFrame(AVMediaTyp
 	int64_t pts = decodedFrame->best_effort_timestamp;
 	int streamIdx = (type == AVMEDIA_TYPE_VIDEO ? _videoStreamIndex : _audioStreamIndex);
 	double timebase = ExtLibs::av_q2d(_formatContext->streams[streamIdx]->time_base);
-	double duration = decodedFrame->pkt_duration * timebase;
+	double duration = decodedFrame->duration * timebase;
 	double framestart = pts * timebase;
 	framestart += _loopNumber * _loopDuration;
 
