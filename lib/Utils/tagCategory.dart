import 'package:flutter/material.dart';

class TagCategory {
  final List<String> tags;
  final Color color;

  TagCategory({required this.tags, required this.color});
}

class SectionTags {
  final TagCategory positive;
  final TagCategory negative;

  SectionTags({required this.positive, required this.negative});
}

final Map<String, SectionTags> sectionTags = {
  'Living Room': SectionTags(
    positive: TagCategory(
      tags: ['Spacious', 'Bright', 'Fireplace', 'High ceilings', 'Hardwood'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Small', 'Dark', 'Low ceilings', 'Carpet'],
      color: Colors.red[100]!,
    ),
  ),
  'Dining Room': SectionTags(
    positive: TagCategory(
      tags: ['Formal', 'Open', 'Natural light', 'Large'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Cramped', 'Closed off', 'Dark'],
      color: Colors.red[100]!,
    ),
  ),
  'Kitchen': SectionTags(
    positive: TagCategory(
      tags: ['Modern', 'Updated appliances', 'Open layout', 'Granite'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: [
        'Outdated',
        'Small',
        'No storage',
        'Cramped',
        'Dark',
        'Old Appliances'
      ],
      color: Colors.red[100]!,
    ),
  ),
  'Master Bedroom': SectionTags(
    positive: TagCategory(
      tags: ['Large', 'Walk-in closet', 'En-suite', 'Bright'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Small', 'No closet space', 'Dark'],
      color: Colors.red[100]!,
    ),
  ),
  'Additional Bedrooms': SectionTags(
    positive: TagCategory(
      tags: ['Good size', 'Bright', 'Closet space'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Small', 'Dark', 'No closet'],
      color: Colors.red[100]!,
    ),
  ),
  'Guest Bedroom': SectionTags(
    positive: TagCategory(
      tags: ['Spacious', 'Bright', 'Closet space'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Tiny', 'Dark', 'No closet'],
      color: Colors.red[100]!,
    ),
  ),
  'Home Office': SectionTags(
    positive: TagCategory(
      tags: ['Quiet', 'Bright', 'Large windows', 'Built-ins'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Noisy', 'Small', 'Dark'],
      color: Colors.red[100]!,
    ),
  ),
  'Bathroom': SectionTags(
    positive: TagCategory(
      tags: ['Updated', 'Double vanity', 'Walk-in shower', 'Soaking tub'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Outdated', 'Small', 'Mold', 'Cracked tiles'],
      color: Colors.red[100]!,
    ),
  ),
  'Backyard': SectionTags(
    positive: TagCategory(
      tags: ['Large', 'Fenced', 'Patio', 'Landscaping'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Small', 'Overgrown', 'No privacy'],
      color: Colors.red[100]!,
    ),
  ),
  'Front Yard': SectionTags(
    positive: TagCategory(
      tags: ['Curb appeal', 'Landscaped', 'Low maintenance'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Unkempt', 'Overgrown', 'No landscaping'],
      color: Colors.red[100]!,
    ),
  ),
  'Pool': SectionTags(
    positive: TagCategory(
      tags: ['Well-maintained', 'Heated', 'In-ground', 'Fenced', 'Saltwater'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Unmaintained', 'Cracked', 'Above-ground', 'Safety concerns'],
      color: Colors.red[100]!,
    ),
  ),
  'View': SectionTags(
    positive: TagCategory(
      tags: ['Scenic', 'Ocean view', 'Mountain view', 'City lights'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Obstructed', 'Poor view'],
      color: Colors.red[100]!,
    ),
  ),
  'Basement': SectionTags(
    positive: TagCategory(
      tags: ['Finished', 'Dry', 'Multi-purpose', 'Storage'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Unfinished', 'Damp', 'Mold', 'Dark'],
      color: Colors.red[100]!,
    ),
  ),
  'Garage': SectionTags(
    positive: TagCategory(
      tags: ['Spacious', '2-car or more', 'Shelving', 'Insulated'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Small', 'Cluttered', 'No storage'],
      color: Colors.red[100]!,
    ),
  ),
  'Neighborhood': SectionTags(
    positive: TagCategory(
      tags: ['Friendly', 'Safe', 'Walkable', 'Vibrant', 'Convenient'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Noisy', 'Unsafe', 'Poorly maintained'],
      color: Colors.red[100]!,
    ),
  ),
  'Schools': SectionTags(
    positive: TagCategory(
      tags: [
        'Top-rated',
        'Great reviews',
        'High test scores',
        'Close proximity'
      ],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Low ratings', 'Far away', 'Poor facilities'],
      color: Colors.red[100]!,
    ),
  ),
  'Price': SectionTags(
    positive: TagCategory(
      tags: ['Affordable', 'Good value', 'Competitive'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Overpriced', 'High taxes', 'Hidden fees'],
      color: Colors.red[100]!,
    ),
  ),
  'HOA': SectionTags(
    positive: TagCategory(
      tags: ['Well-managed', 'Community events', 'Good amenities'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['High fees', 'Strict rules', 'Poor communication'],
      color: Colors.red[100]!,
    ),
  ),
  'House Size': SectionTags(
    positive: TagCategory(
      tags: ['Spacious', 'Open floor plan', 'Room for growth'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Cramped', 'Too large', 'Difficult to maintain'],
      color: Colors.red[100]!,
    ),
  ),
  'Overall House': SectionTags(
    positive: TagCategory(
      tags: ['Well-maintained', 'Move-in ready', 'Great layout'],
      color: Colors.green[100]!,
    ),
    negative: TagCategory(
      tags: ['Needs repairs', 'Outdated', 'Poor design'],
      color: Colors.red[100]!,
    ),
  ),
};
