
progress += spd;
if (progress > 1) instance_destroy();

image_xscale = animcurve_channel_evaluate(curveChannelScale, progress) * scale;
image_yscale = image_xscale;
image_alpha = animcurve_channel_evaluate(curveChannelAlpha, progress);
