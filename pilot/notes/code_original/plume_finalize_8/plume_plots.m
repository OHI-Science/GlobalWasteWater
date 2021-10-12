% plume_plots.m
% -------------
% Simple matlab script to plot plume raster results.

diff_pest_raw=imread('global_plumes_pest_2011_2012_raw_minus_2007_2010_raw.tif');
diff_pest_raw_pos=diff_pest_raw(find(diff_pest_raw>0));
figure;hist(log10(diff_pest_raw_pos(:)),100);
xlim([-10 5]);ylim([0 2e5]);
xlabel('log10(positive differences in pesticide consumption [tonnes]) between 2007-2010 and 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of positive differences in pesticide use per pixel between 2007-2010 and 2011-2012');

diff_pest_raw_neg=abs(diff_pest_raw(find(diff_pest_raw<0)));
figure;hist(log10(diff_pest_raw_neg(:)),100);
xlim([-10 5]);ylim([0 2e5]);
xlabel('log10(absolute value(negative differences in pesticide consumption [tonnes])) between 2007-2010 and 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of negative differences in pesticide use per pixel between 2007-2010 and 2011-2012');

diff_fert_raw=imread('global_plumes_fert_2011_2012_raw_minus_2007_2010_raw.tif');
diff_fert_raw_pos=diff_fert_raw(find(diff_fert_raw>0));
figure;hist(log10(diff_fert_raw_pos(:)),100);
xlim([-10 5]);ylim([0 2e5]);
xlabel('log10(positive differences in fertilizer consumption [tonnes]) between 2007-2010 and 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of positive differences in fertilizer use per pixel between 2007-2010 and 2011-2012');

diff_fert_raw_neg=abs(diff_fert_raw(find(diff_fert_raw<0)));
figure;hist(log10(diff_fert_raw_neg(:)),100);
xlim([-10 5]);ylim([0 2e5]);
xlabel('log10(absolute value(negative differences in fertilizer consumption [tonnes])) between 2007-2010 and 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of negative differences in fertilizer use per pixel between 2007-2010 and 2011-2012');

plumes_pest_2007_2010=imread('global_plumes_pest_2007_2010_raw.tif');
plumes_pest_2007_2010_nonzero=plumes_pest_2007_2010(find(plumes_pest_2007_2010~=0));
figure;hist(log10(plumes_pest_2007_2010_nonzero(:)),100);
xlabel('log10(non-zero pesticide use [tonnes]) 2007-2010');
ylabel('frequency (1km^2 pixels)');
title('log histogram of pesticide use pixel distribution, 2007-2010');
xlim([-8 4]);

plumes_pest_2011_2012=imread('global_plumes_pest_2011_2012_raw.tif');
plumes_pest_2011_2012_nonzero=plumes_pest_2011_2012(find(plumes_pest_2011_2012~=0));
figure;hist(log10(plumes_pest_2011_2012_nonzero(:)),100);
xlabel('log10(non-zero pesticide use [tonnes]) 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of pesticide use pixel distribution, 2011-2012');
xlim([-8 4]);

plumes_fert_2007_2010=imread('global_plumes_fert_2007_2010_raw.tif');
plumes_fert_2007_2010_nonzero=plumes_fert_2007_2010(find(plumes_fert_2007_2010~=0));
figure;hist(log10(plumes_fert_2007_2010_nonzero(:)),100);
xlabel('log10(non-zero fertilizer use [tonnes]) 2007-2010');
ylabel('frequency (1km^2 pixels)');
title('log histogram of fertilizer use pixel distribution, 2007-2010');
xlim([-5 5]);

plumes_fert_2011_2012=imread('global_plumes_fert_2011_2012_raw.tif');
plumes_fert_2011_2012_nonzero=plumes_fert_2011_2012(find(plumes_fert_2011_2012~=0));
figure;hist(log10(plumes_fert_2011_2012_nonzero(:)),100);
xlabel('log10(non-zero fertilizer consumption [tonnes]) 2011-2012');
ylabel('frequency (1km^2 pixels)');
title('log histogram of fertilizer consumption pixel distribution, 2011-2012');
xlim([-5 5]);
