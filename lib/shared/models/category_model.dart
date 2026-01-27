class Category {
  final String id;
  final String name;
  final String icon;
  final String image;
  final String description;
  final String color;
  final int experienceCount;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.description,
    required this.color,
    this.experienceCount = 0,
    this.isActive = true,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      experienceCount: json['experienceCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image': image,
      'description': description,
      'color': color,
      'experienceCount': experienceCount,
      'isActive': isActive,
    };
  }

  // Default categories for Bihar Tourism
  static List<Category> get defaultCategories => [
        Category(
          id: 'spiritual',
          name: 'Spiritual',
          icon: '🙏',
          image: 'https://images.unsplash.com/photo-1545378889-a8e6e2df4738?w=800',
          description: 'Buddhist pilgrimages and spiritual journeys',
          color: '#FF6B35',
          experienceCount: 25,
        ),
        Category(
          id: 'heritage',
          name: 'Heritage',
          icon: '🏛️',
          image: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
          description: 'Ancient ruins and historical monuments',
          color: '#8B4513',
          experienceCount: 18,
        ),
        Category(
          id: 'food',
          name: 'Food',
          icon: '🍛',
          image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?w=800',
          description: 'Authentic Bihari cuisine experiences',
          color: '#E67E22',
          experienceCount: 15,
        ),
        Category(
          id: 'nature',
          name: 'Nature',
          icon: '🌿',
          image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          description: 'Ganga river activities and wildlife',
          color: '#27AE60',
          experienceCount: 12,
        ),
        Category(
          id: 'adventure',
          name: 'Adventure',
          icon: '🚣',
          image: 'https://images.unsplash.com/photo-1530866495561-507c9faab2ed?w=800',
          description: 'Exciting outdoor activities',
          color: '#9B59B6',
          experienceCount: 8,
        ),
        Category(
          id: 'cultural',
          name: 'Cultural',
          icon: '🎭',
          image: 'https://images.unsplash.com/photo-1533669955142-6a73332af4db?w=800',
          description: 'Village stays and cultural immersion',
          color: '#3498DB',
          experienceCount: 20,
        ),
      ];
}
