import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../containers/custom_shimmer.dart';
import 'widgets/custom_photo_view.dart';
import 'widgets/image_error.dart';

class ImageUrl extends StatelessWidget {
  const ImageUrl({
    super.key,
    required this.fit,
    required this.url,
    required this.headers,
    required this.cacheKey,
    required this.imageSize,
    required this.cacheManager,
    required this.errorBuilder,
    required this.maxWidthDiskCache,
    required this.maxHeightDiskCache,
  });

  final BoxFit fit;
  final String url;
  final String? cacheKey;
  final Size? imageSize;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Map<String, String>? headers;
  final BaseCacheManager? cacheManager;
  final Widget Function(String)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(
        child: CustomShimmer(
          width: imageSize?.width ?? 32,
          height: imageSize?.height ?? 32,
        ),
      ),
      cacheKey: cacheKey,
      cacheManager: cacheManager,
      maxHeightDiskCache: maxHeightDiskCache,
      maxWidthDiskCache: maxWidthDiskCache,
      httpHeaders: headers,
      imageBuilder: (context, image) {
        return Semantics(
          button: true,
          child: InkWell(
            onTap: () => CustomPhotoView(image: image).show(context),
            child: Image(image: image, fit: fit),
          ),
        );
      },
      errorWidget: (context, url, error) =>
          errorBuilder?.call(error.toString()) ??
          ImageError(error: error.toString()),
    );
  }
}
