// lib/data/dummy_menu_items.dart

import '../models/menu_item.dart';

List<MenuItem> dummyMenuItems = [
  // ── Iya Basira's Kitchen (vendorId: 1) ──
  MenuItem(
    id: '1',
    vendorId: '1',
    name: 'Jollof Rice Combo',
    description:
        'Smoky party-style jollof rice with fried plantain and 1 piece of chicken. The most ordered meal on campus.',
    price: 2800,
    category: 'Rice meals',
    imageUrl:
        'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800',
    tags: ['Best seller'],
    preparationTime: '15 min',
  ),
  MenuItem(
    id: '2',
    vendorId: '1',
    name: 'Fried Rice + Turkey',
    description:
        'Colourful fried rice served with peppered turkey. Great for sharing or evening cravings.',
    price: 3500,
    category: 'Rice meals',
    imageUrl:
        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800',
    tags: ['Popular', 'Student special'],
    preparationTime: '18 min',
  ),
  MenuItem(
    id: '3',
    vendorId: '1',
    name: 'Ofada Rice Special',
    description:
        'Local ofada rice with rich ayamase sauce, assorted meat and boiled eggs. Authentic Naija taste.',
    price: 2500,
    category: 'Rice meals',
    imageUrl:
        'https://images.unsplash.com/photo-1516684732162-798a0062be99?w=800',
    tags: ['Popular'],
    preparationTime: '15 min',
  ),
  MenuItem(
    id: '4',
    vendorId: '1',
    name: 'Beans & Plantain',
    description:
        'Soft honey beans with sweet fried plantain and pepper sauce. Best budget meal on campus.',
    price: 1800,
    category: 'Popular picks',
    imageUrl:
        'https://images.unsplash.com/photo-1598511726623-d2e9996892f0?w=800',
    tags: ['Budget pick', 'Under ₦2k'],
    preparationTime: '12 min',
  ),

  // ── Campus Bite Burgers (vendorId: 2) ──
  MenuItem(
    id: '5',
    vendorId: '2',
    name: 'Classic Beef Burger',
    description:
        'Juicy beef patty with lettuce, tomato, onion and special sauce in a toasted bun.',
    price: 2200,
    category: 'Burgers',
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    tags: ['Best seller'],
    preparationTime: '12 min',
  ),
  MenuItem(
    id: '6',
    vendorId: '2',
    name: 'Chicken Burger + Fries',
    description:
        'Crispy fried chicken fillet burger served with seasoned fries. Student favourite for quick lunch.',
    price: 2600,
    category: 'Burgers',
    imageUrl:
        'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800',
    tags: ['Popular', 'Student special'],
    preparationTime: '15 min',
  ),
  MenuItem(
    id: '7',
    vendorId: '2',
    name: 'Peppered Chicken Wings',
    description:
        'Spicy marinated chicken wings fried to perfection. Comes with dipping sauce.',
    price: 1900,
    category: 'Snacks',
    imageUrl:
        'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=800',
    tags: ['Budget pick'],
    preparationTime: '18 min',
  ),
  MenuItem(
    id: '8',
    vendorId: '2',
    name: 'Loaded Fries',
    description:
        'Crispy fries topped with melted cheese, chicken strips and jalapeños. Great sharing snack.',
    price: 1500,
    category: 'Snacks',
    imageUrl:
        'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=800',
    tags: ['Budget pick', 'Under ₦2k'],
    preparationTime: '10 min',
  ),

  // ── Mama Put Delicacies (vendorId: 3) ──
  MenuItem(
    id: '9',
    vendorId: '3',
    name: 'Amala + Egusi',
    description:
        'Smooth amala with thick egusi soup and assorted beef. The most filling meal for long lecture days.',
    price: 3200,
    category: 'Swallow',
    imageUrl:
        'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=800',
    tags: ['Heavy meal', 'Includes protein'],
    preparationTime: '20 min',
  ),
  MenuItem(
    id: '10',
    vendorId: '3',
    name: 'Pounded Yam + Egusi',
    description:
        'Smooth pounded yam with rich egusi soup, dried fish and stockfish. Classic Naija comfort food.',
    price: 3000,
    category: 'Swallow',
    imageUrl:
        'https://images.unsplash.com/photo-1569058242253-92a9c755a0ec?w=800',
    tags: ['Heavy meal'],
    preparationTime: '22 min',
  ),
  MenuItem(
    id: '11',
    vendorId: '3',
    name: 'Tuwo Shinkafa + Miyan Kuka',
    description:
        'Northern classic — soft tuwo rice with miyan kuka soup and beef. Authentic Kano taste.',
    price: 2200,
    category: 'Swallow',
    imageUrl:
        'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
    tags: ['Popular', 'Student special'],
    preparationTime: '20 min',
  ),
  MenuItem(
    id: '12',
    vendorId: '3',
    name: 'Masa + Miyan Taushe',
    description:
        'Fluffy masa rice cakes served with rich miyan taushe pumpkin soup. Light and delicious.',
    price: 1600,
    category: 'Popular picks',
    imageUrl:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
    tags: ['Budget pick', 'Under ₦2k'],
    preparationTime: '15 min',
  ),

  // ── Sharwarma Palace (vendorId: 4) ──
  MenuItem(
    id: '13',
    vendorId: '4',
    name: 'Chicken Shawarma',
    description:
        'Grilled chicken strips wrapped in soft flatbread with coleslaw, sauce and vegetables.',
    price: 2000,
    category: 'Shawarma',
    imageUrl: 'https://images.unsplash.com/photo-1561050501-a571e6993aa4?w=800',
    tags: ['Best seller', 'Student special'],
    preparationTime: '10 min',
  ),
  MenuItem(
    id: '14',
    vendorId: '4',
    name: 'Beef Shawarma',
    description:
        'Seasoned beef strips in toasted flatbread with garlic sauce, pickles and fresh veggies.',
    price: 2300,
    category: 'Shawarma',
    imageUrl:
        'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800',
    tags: ['Popular'],
    preparationTime: '12 min',
  ),
  MenuItem(
    id: '15',
    vendorId: '4',
    name: 'Suya Platter',
    description:
        'Smoky spiced beef suya skewers served with sliced onions, tomatoes and yaji spice.',
    price: 2500,
    category: 'Grills',
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
    tags: ['Popular', 'Includes protein'],
    preparationTime: '20 min',
  ),

  // ── Zainab's Swallow Spot (vendorId: 5) ──
  MenuItem(
    id: '16',
    vendorId: '5',
    name: 'Eba + Okra Soup',
    description:
        'Fresh eba with draw okra soup loaded with assorted fish and beef. Mama\'s recipe.',
    price: 2400,
    category: 'Swallow',
    imageUrl:
        'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800',
    tags: ['Heavy meal', 'Includes protein'],
    preparationTime: '18 min',
  ),
  MenuItem(
    id: '17',
    vendorId: '5',
    name: 'Semovita + Ogbono',
    description:
        'Smooth semovita with thick ogbono soup, assorted meat and leafy greens.',
    price: 2800,
    category: 'Swallow',
    imageUrl:
        'https://images.unsplash.com/photo-1604329760661-e71dc83f8f26?w=800',
    tags: ['Heavy meal'],
    preparationTime: '20 min',
  ),
  MenuItem(
    id: '18',
    vendorId: '5',
    name: 'Rice + Stew & Chicken',
    description:
        'White rice with rich tomato stew and a full piece of chicken. Simple, filling, satisfying.',
    price: 2000,
    category: 'Rice meals',
    imageUrl:
        'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800',
    tags: ['Budget pick', 'Student special'],
    preparationTime: '15 min',
  ),
];
