import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        );

  const CustomShimmer.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
            shape: widget.shapeBorder,
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + _controller.value * 2, -0.3),
              end: Alignment(1.0 + _controller.value * 2, 0.3),
            ),
          ),
        );
      },
    );
  }
}

class UserCardShimmer extends StatelessWidget {
  const UserCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Circular Avatar Shimmer
          const CustomShimmer.circular(width: 54, height: 54),
          const SizedBox(width: 16),
          // Info Block Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomShimmer.rectangular(height: 16, width: 140),
                const SizedBox(height: 8),
                const CustomShimmer.rectangular(height: 12, width: 80),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CustomShimmer.circular(width: 12, height: 12),
                    const SizedBox(width: 6),
                    const CustomShimmer.rectangular(height: 10, width: 120),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CustomShimmer.circular(width: 12, height: 12),
                    const SizedBox(width: 6),
                    const CustomShimmer.rectangular(height: 10, width: 90),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Blood Group Badge Shimmer
          const CustomShimmer.rectangular(height: 32, width: 50),
        ],
      ),
    );
  }
}
