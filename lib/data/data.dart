import '../models/models.dart';

final List<Hotel> hotels = [
  Hotel(
    id: '1', // Keeping the ID as '1' since the app uses hotels.first
    name: 'The Kiliyur Resort',
    location:
        'Nestled in the Shevaroy Hills, Tamil Nadu, overlooking misty valleys and coffee plantations.',
    rating: 4.5, // Reasonable default based on a premier resort
    reviews: 1069, // Arbitrary but plausible number
    price: 2000, // Lowest per-night rate from rooms (Garden Cottage)
    description:
        'Nestled in the heart of Yercaud’s Shevaroy Hills, The Kiliyur Resort blends luxury and comfort with breathtaking panoramic views. Enjoy warm, attentive hospitality, diverse dining options and well-appointed accommodations—plus a range of adventure activities—to relax, recharge and reconnect with nature.',
    imageUrls: [
      'https://hotelshevaroys.com/wp-content/uploads/2022/08/leisure-beautiful-health-garden-landscape_1203-4856.webp',
    ],
    amenities: [
      'Swimming Pool',
      'Restaurant',
      'Spa',
      'Fitness Center',
      'Free Wi-Fi',
      'Parking',
      'Room Service',
      'Conference Hall',
      'Garden',
      'Bonfire',
    ], // Common resort amenities
    rooms: [
      // Updated Hotel and Room Data with the full information from files
      Room(
        id: '1',
        name: 'Honeymoon Haven',
        price: 4300, // Weekly rate divided by 7 = approx per night rate
        capacity: 2,
        size: 90,
        imageUrls: [
          'https://images.unsplash.com/photo-1668435528344-b70cedd6df88?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://images.unsplash.com/photo-1668435528609-e03279db1748?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDF8fHxlbnwwfHx8fHw%3D',
          'https://images.unsplash.com/photo-1689729738817-fb1f4256769d?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDV8fHxlbnwwfHx8fHw%3D',
        ],
        features: [
          'Free Wi-Fi',
          'TV',
          'Air Conditioning',
          'Room Service',
          'Attached Bathroom',
          'Romantic Decor',
          'Mood Lighting System',
          'Premium Sound System',
        ],
        description:
            'Designed specifically for couples celebrating love, our 90 sq.m Honeymoon Haven offers the ultimate romantic escape. The centerpiece is a stunning canopy bed draped in sheer fabrics, while the private outdoor jacuzzi provides a magical setting for stargazing. Thoughtful romantic touches throughout create an atmosphere of intimacy and luxury perfect for newlyweds and couples.',
        bestFor: 'Honeymooners, anniversary celebrations, romantic getaways',
        accommodationDetails: {
          'Bed': 'Luxurious king-size canopy bed',
          'Bathroom': 'Oversized bathroom with dual rainfall showers',
          'Lounge': 'Indoor relaxation lounge with loveseat',
          'Outdoor': 'Private jacuzzi on secluded terrace',
          'Lighting': 'Mood lighting system',
          'Entertainment': 'Premium sound system with romantic playlists',
          'Welcome': 'Complimentary bottle of champagne',
          'Service': 'Rose petal turndown service on arrival',
        },
        bookingInformation: {
          'Maximum occupancy': '2 adults',
          'Weekly rate': '\$4,300',
          'Monthly rate': '\$15,500',
          'Complimentary services': [
            'Couples\' massage (60 minutes)',
            'Private beachfront dinner for two',
            'Late checkout until 4 PM (subject to availability)',
            'Honeymoon photo session (30 minutes)',
          ],
        },
        specialFeatures: [
          'Romantic ambiance throughout',
          'Private jacuzzi',
          'Canopy bed',
          'Sunset-facing orientation',
          'Customizable romance packages',
        ],
      ),

      Room(
        id: '2',
        name: 'Deluxe Suite',
        price: 4500, // Weekly rate directly from data
        capacity: 4,
        size: 110,
        imageUrls: [
          'https://images.unsplash.com/photo-1662385930165-49ebaa03b152?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/411214459.jpg?k=d27447b6fc2c2e77a9f9958ed9bd6d128a37eb2a5fb6f94b987d5386b1758310&o=',
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/411411371.jpg?k=50ae704a01d4d1898caa0f842bf28a086de940200a692faf1aff40f41fcd96c2&o=',
        ],
        features: [
          'Free Wi-Fi',
          'Premium King-Size Bed',
          'Sofa Bed',
          'Smart Home Controls',
          'Premium Entertainment System',
          'Indoor-Outdoor Living',
        ],
        description:
            'Experience refined luxury in our 110 sq.m Deluxe Suites. These beautifully appointed accommodations feature a spacious bedroom, separate living area, and a private pool set within a walled tropical garden. The contemporary design incorporates natural materials and soothing color palettes to create a tranquil retreat perfect for relaxation and rejuvenation.',
        bestFor: 'Couples seeking space, small families, extended stays',
        accommodationDetails: {
          'Bedroom': 'Master bedroom with premium king-size bed',
          'Living Area': 'Sofa bed in living room for additional guests',
          'Bathroom':
              'Elegant bathroom with deep soaking tub and separate shower',
          'Design': 'Indoor-outdoor living concept with sliding glass doors',
          'Dining': 'Covered outdoor dining area',
          'Controls': 'Smart home controls for lighting and temperature',
          'Entertainment': 'Premium entertainment system',
          'Amenities': 'Daily tropical fruit basket',
        },
        bookingInformation: {
          'Maximum occupancy': '4 adults (or 2 adults and 2 children)',
          'Weekly rate': '\$4,500',
          'Monthly rate': '\$16,000',
          'Complimentary services': [
            'Airport transfers',
            'Welcome drink and cold towels upon arrival',
            'Personalizable minibar (preferences noted before arrival)',
          ],
        },
        specialFeatures: [
          'Private swimming pool',
          'Expansive garden terrace',
          'Indoor-outdoor living concept',
          'Evening turndown with aromatherapy option',
        ],
      ),

      Room(
        id: '3',
        name: 'Beach Bungalow',
        price: 2900, // Weekly rate directly from data
        capacity: 2,
        size: 80,
        imageUrls: [
          'https://images.unsplash.com/photo-1630999295881-e00725e1de45?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?q=80&w=2049&auto=format&fit=crop&ixlib=rb-4.0.3',
        ],
        features: [
          'Direct Beach Access',
          'King-Size Bed with Ocean Views',
          'Indoor and Outdoor Showers',
          'Smart TV',
          'Bluetooth Speaker System',
        ],
        description:
            'Step directly onto pristine white sands from your private Beach Bungalow. These charming 80 sq.m accommodations blend traditional island architecture with modern comforts, featuring direct beach access and a secluded outdoor shower garden. Enjoy the sound of gentle waves from your covered veranda equipped with comfortable loungers and a dining area.',
        bestFor: 'Beach lovers, couples seeking privacy, ocean enthusiasts',
        accommodationDetails: {
          'Bed': 'King-size bed with ocean views',
          'Bathroom': 'Indoor and outdoor showers with luxury amenities',
          'Outdoor': 'Private veranda with beach access',
          'Refreshments': 'Minibar restocked daily with complimentary items',
          'Climate': 'Air conditioning and ceiling fans',
          'Entertainment': '50" Smart TV with streaming capabilities',
          'Audio': 'Bluetooth speaker system',
        },
        bookingInformation: {
          'Maximum occupancy': '2 adults',
          'Weekly rate': '\$2,900',
          'Monthly rate': '\$10,500',
          'Complimentary services': [
            'Daily breakfast included',
            'Beach amenity kit provided (snorkels, fins, beach games)',
            'Early check-in/late checkout based on availability',
          ],
        },
        specialFeatures: [
          'Direct beach access',
          'Outdoor garden shower',
          'Sunset-facing private veranda',
          'Dedicated beach loungers',
        ],
      ),

      Room(
        id: '4',
        name: 'Emerald Villa',
        price: 3900, // Weekly rate directly from data
        capacity: 3,
        size: 100,
        imageUrls: [
          'https://images.unsplash.com/photo-1662841540530-2f04bb3291e8?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjJ8fFJvb21zJTIwaW4lMjByZXNvcnR8ZW58MHx8MHx8fDI%3D',
          'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3',
        ],
        features: [
          'Direct Lagoon Access',
          'Four-Poster King Bed',
          'Premium Bath Amenities',
          'iPad Room Control',
          'Evening Turndown Service',
        ],
        description:
            'Our exclusive 100 sq.m Emerald Villas offer direct access to the crystal-clear lagoon from a private deck. These luxuriously designed accommodations feature vaulted ceilings, custom furnishings, and a harmonious blend of indoor and outdoor living spaces. The sophisticated interiors showcase local artwork and handcrafted elements that reflect the island\'s rich cultural heritage.',
        bestFor: 'Nature lovers, water enthusiasts, design aficionados',
        accommodationDetails: {
          'Bed': 'King-size four-poster bed with premium linens',
          'Bathroom': 'Spacious bathroom with outdoor elements',
          'Living': 'Living area with comfortable seating',
          'Work': 'Writing desk with lagoon views',
          'Refreshments': 'Minibar with premium spirits and local specialties',
          'Technology': 'iPad with resort information and room controls',
          'Amenities': 'L\'Occitane bath amenities',
          'Service': 'Evening turndown service',
        },
        bookingInformation: {
          'Maximum occupancy': '3 adults (or 2 adults and 2 children)',
          'Weekly rate': '\$3,900',
          'Monthly rate': '\$14,000',
          'Complimentary services': [
            'Daily breakfast included',
            'Complimentary sunset cocktails',
            'Kayaks and paddleboards available at villa',
            'Priority restaurant reservations',
          ],
        },
        specialFeatures: [
          'Direct lagoon access',
          'Private lounging deck',
          'Architectural design elements',
          'Exclusive Emerald Club access',
        ],
      ),

      Room(
        id: '5',
        name: 'Family Suite',
        price: 5600, // Weekly rate directly from data
        capacity: 6,
        size: 150,
        imageUrls: [
          'https://images.unsplash.com/photo-1594130139005-3f0c0f0e7c5e?q=80&w=2012&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/411411359.jpg?k=91eeb02325d2782f61daa6d426869d21369a05d04296c14b91e62710988698fd&o=',
          'https://images.unsplash.com/photo-1564078516393-cf04bd966897?q=80&w=2041&auto=format&fit=crop&ixlib=rb-4.0.3',
        ],
        features: [
          'Two Separate Bedrooms',
          'Kids\' Corner with Bunk Beds',
          'Family Dining Area',
          'Kitchenette',
          'Child Safety Features',
          'Entertainment System with Family Movies',
        ],
        description:
            'Created with larger families in mind, our 150 sq.m Family Suites offer generous living spaces including two separate bedrooms, a dedicated kids\' area, and comfortable common spaces. These thoughtfully designed accommodations provide both togetherness and privacy, with child-friendly features throughout and expansive outdoor living areas perfect for family time.',
        bestFor:
            'Families with children, multi-generational travel, extended family stays',
        accommodationDetails: {
          'Master Bedroom': 'Master bedroom with king-size bed',
          'Second Bedroom': 'Second bedroom with two queen beds',
          'Kids\' Area': 'Kids\' corner with bunk beds and play area',
          'Bathrooms': 'Two full bathrooms plus additional half bath',
          'Living Room': 'Spacious living room with sectional sofa',
          'Dining': 'Family dining table for 6',
          'Kitchen': 'Kitchenette with microwave, mini-fridge, and essentials',
          'Entertainment': 'Entertainment system with family movie selection',
          'Safety': 'Child safety features throughout',
        },
        bookingInformation: {
          'Maximum occupancy': '6 adults (or 4 adults and 4 children)',
          'Weekly rate': '\$5,600',
          'Monthly rate': '\$20,000',
          'Complimentary services': [
            'Complimentary first-night family dinner',
            'Kids welcome amenities',
            'Baby essentials available (sterilizer, bottle warmer, etc.)',
            'Option to pre-stock kitchen with family favorites',
          ],
        },
        specialFeatures: [
          'Child-friendly design',
          'Separate kids\' sleeping area',
          'Family-sized outdoor space',
          'Game console',
          'Access to Family Club benefits',
        ],
      ),
    ],
    diningOptions: [
      DiningOption(
        id: '1',
        name: 'Valley View Restaurant',
        cuisines: ['Seafood', 'International', 'Indian'],
        openingHours: '7:00 AM - 10:00 PM',
        imageUrl:
            'https://images.unsplash.com/photo-1722108539182-f25a8fe53ead?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'Dine with breathtaking valley views at our signature restaurant. Featuring a diverse menu of coastal seafood, global favorites, and authentic Indian dishes prepared with locally sourced ingredients.',
        highlights: [
          'Live cooking stations',
          'Valley-view seating',
          'Family-friendly ambiance',
        ],
        seatBookingPrice:
            500.0, // Moderate price for a signature restaurant with views
      ),
      DiningOption(
        id: '2',
        name: 'Grill & Spice Terrace',
        cuisines: ['BBQ', 'Asian'],
        openingHours: '12:00 PM - 11:00 PM',
        imageUrl:
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'A rooftop dining experience featuring grilled delicacies and Asian specialties. Perfect for an afternoon feast or a romantic dinner under the stars.',
        highlights: [
          'Live BBQ grills',
          'Scenic terrace seating',
          'Weekend live music',
        ],
        seatBookingPrice: 600.0, // Slightly higher for rooftop and live music
      ),
      DiningOption(
        id: '3',
        name: 'Lagoon Cafe',
        cuisines: ['Mediterranean', 'Light Bites'],
        openingHours: '8:00 AM - 8:00 PM',
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1724707432836-aefde6bffb72?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'Relax with refreshing beverages and light Mediterranean fare beside the resort\'s serene pool. Ideal for a quick bite or a peaceful afternoon.',
        highlights: [
          'Poolside ambiance',
          'Light, healthy menu',
          'Ideal for casual hangouts',
        ],
        seatBookingPrice: 300.0, // Lower price for casual, poolside dining
      ),
      DiningOption(
        id: '4',
        name: 'Sky Lounge & Bar',
        cuisines: ['Cocktails', 'Tapas'],
        openingHours: '4:00 PM - 11:00 PM',
        imageUrl:
            'https://images.unsplash.com/photo-1582417746333-30354bba843e?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'Unwind with signature cocktails and gourmet tapas while enjoying the best panoramic views of Yercaud\'s hills. A perfect place to end your day.',
        highlights: [
          'Hilltop views',
          'Signature cocktail menu',
          'Cozy lounge vibe',
        ],
        seatBookingPrice:
            700.0, // Higher for premium lounge experience with views
      ),
      DiningOption(
        id: '5',
        name: 'Private Dining Experience',
        cuisines: ['Specialty', 'Curated Specialty Menus'],
        openingHours: 'By Reservation',
        imageUrl:
            'https://images.unsplash.com/photo-1714692531066-aa097fd4e4cc?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'For intimate occasions or special celebrations, enjoy a personalized dining experience with custom menus and a private setup.',
        highlights: [
          'Custom themes and décor',
          'Private butler service',
          'Perfect for proposals or family dinners',
        ],
        seatBookingPrice: 1500.0, // Highest for exclusive, private setup
      ),
    ],
    packages: [
      Package(
        id: '1',
        name: 'Honeymoon Package',
        price: 15000,
        description:
            'Special package for couples with romantic dinner and activities.',
        inclusions: [
          '2 Nights Stay',
          'Romantic Dinner',
          'Spa Session',
          'Sightseeing',
        ],
      ),
      Package(
        id: '2',
        name: 'Adventure Package',
        price: 12000,
        description:
            'Exciting package with adventure activities and comfortable stay.',
        inclusions: [
          '2 Nights Stay',
          'Adventure Activities',
          'Bonfire',
          'Complimentary Meals',
        ],
      ),
      Package(
        id: '3',
        name: 'Family Getaway',
        price: 18000,
        description:
            'Perfect package for family vacation with activities for all.',
        inclusions: [
          '2 Nights Stay',
          'Family Activities',
          'Sightseeing',
          'Complimentary Meals',
          'Indoor Games',
        ],
      ),
    ],
    events: [
      EventType(
        id: '1',
        name: 'Birthday Celebration',
        shortDescription: 'Private setups with themes, cakes & entertainment.',
        description:
            'Celebrate your special day with a fully customizable birthday setup—perfect for kids, teens, or adults. We offer themed décor, custom cakes, music, games, and catering.',
        capacity: 'Up to 100 guests',
        inclusions: [
          'Theme-based décor',
          'Custom cake & catering',
          'AV setup for music/entertainment',
          'Kids’ games and activities (on request)',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1741969494307-55394e3e4071?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      EventType(
        id: '2',
        name: 'Marriage Ceremony',
        shortDescription:
            'Scenic venues, floral décor, and curated wedding packages.',
        description:
            'Host your dream wedding amidst the scenic hills of Yercaud. From intimate functions to grand celebrations, we offer venues, decorators, and wedding planners to bring your vision to life.',
        capacity: 'Up to 300 guests',
        inclusions: [
          'Mandap/stage setup',
          'Floral décor & lighting',
          'Wedding planner coordination',
          'Catering & accommodation packages',
          'Photography & entertainment (optional)',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1587271407850-8d438ca9fdf2?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
      EventType(
        id: '3',
        name: 'Conference Hall',
        shortDescription:
            'Fully equipped hall for meetings, seminars, and workshops.',
        description:
            'A modern, fully air-conditioned conference hall ideal for business meetings, training sessions, and corporate events. Equipped with all necessary AV facilities and on-demand refreshments.',
        capacity: '60-seater',
        inclusions: [
          'Projector & screen',
          'High-speed Wi-Fi',
          'Mic & sound system',
          'Seating arrangements (Theatre/Classroom/U-shape)',
          'Tea/coffee & snacks packages',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1588865198054-c83788106132?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      ),
    ],
  ),
];

final List<Map<String, String>> resortPackages = [
  {
    'title': 'Romantic Escape Package',
    'description': 'For couples and honeymooners',
    'image':
        'https://cdn.pixabay.com/photo/2021/11/15/05/54/couple-6796433_1280.jpg',
  },
  {
    'title': 'Thrill-Seeker\'s Adventure Package',
    'description': 'For adults and adventure enthusiasts',
    'image':
        'https://cdn.pixabay.com/photo/2022/06/02/22/39/man-7239061_1280.jpg',
  },
  {
    'title': 'Family Fun Package',
    'description': 'For families up to 6 members',
    'image':
        'https://cdn.pixabay.com/photo/2022/08/17/15/46/family-7392843_1280.jpg',
  },
  {
    'title': 'Budget Nature Retreat',
    'description': 'For solo travelers or couples',
    'image':
        'https://cdn.pixabay.com/photo/2016/11/29/09/49/woman-1868817_1280.jpg',
  },
];
// Data for Land Adventures
final List<Map<String, String>> adventures = [
  {
    'title': 'Low Rope Adventures',
    'description': 'Kid-friendly obstacles at low heights',
    'image':
        'https://cdn.pixabay.com/photo/2022/02/21/14/34/climbing-7026896_1280.jpg',
    'longDescription':
        'Perfect for families with young children, our Low Rope Adventures course offers a safe and exciting introduction to outdoor adventure. Set just a few feet above ground with safety nets below, children can develop confidence, balance, and coordination as they navigate through a series of fun obstacles including rope bridges, cargo nets, balance beams, and mini zip lines. Trained guides provide assistance throughout the experience, making it ideal for children ages 4 and up. The course features 15 different obstacles designed specifically for younger adventurers, providing the perfect mix of challenge and achievement.',
  },
  {
    'title': 'Glass Sky Walk',
    'description': 'Transparent walkway 100 ft above ground',
    'image':
        'https://skyparkyercaud.in/wp-content/uploads/2023/03/glass-sky-walk.jpg',
    'longDescription':
        'Experience the thrill of walking on air with our stunning Glass Sky Walk, perched 100 feet above the valley floor. This engineering marvel features a U-shaped transparent walkway made of reinforced glass that can support over 4,000 pounds per panel. As you step onto the crystal-clear surface, enjoy breathtaking 360-degree panoramic views of the Shevaroy Hills and the lush forests below. Feel your heart race as you look directly down through the transparent floor to the scenic landscape beneath your feet. Professional photographers are available to capture your memorable moment, and informative plaques identify notable landmarks visible from this unique vantage point.',
  },
  {
    'title': 'ATV Ride',
    'description': 'Off-road adventure on rugged terrain',
    'image':
        'https://cdn.pixabay.com/photo/2021/11/18/18/04/ride-6806993_1280.jpg',
    'longDescription':
        'Feel the rush of adrenaline as you conquer Yercaud\'s rugged terrain on our powerful all-terrain vehicles. Our ATV experience features a professionally designed 3.5 km trail that winds through dense forest sections, crosses shallow streams, and navigates challenging muddy slopes. We offer vehicles suitable for beginners and experienced riders alike, with options for solo riding or passenger experiences. Each adventure begins with a comprehensive safety briefing and equipment fitting, and our experienced guides lead small groups to ensure personal attention. The course features multiple scenic viewpoints where you can pause to take in the natural beauty before tackling the next exciting section of trail.',
  },
  {
    'title': 'Trampoline Park',
    'description': 'Bouncing fun for all ages',
    'image':
        'https://skyparkyercaud.in/wp-content/uploads/elementor/thumbs/8-scaled-qgubi0uqsralcmvtuzwqamljxqm9tqocxm1jag5wj0.jpeg',
    'longDescription':
        'Our state-of-the-art Trampoline Park spans over 5,000 square feet of interconnected trampolines, offering endless bouncing fun for visitors of all ages. The park features dedicated zones including a main jumping area, foam pit landing zones, basketball dunk lanes, dodgeball courts, and a special toddler section for our youngest guests. Safety is our priority with padded walls, spring covers, and trained "jump guards" monitoring all activities. Perfect for burning energy, improving coordination, or simply enjoying a gravity-defying experience, our Trampoline Park combines fitness and fun in an exhilarating environment. Special jump sessions include teen nights with music and lights, fitness classes, and family bounce hours.',
  },
  {
    'title': 'Soft Play Area',
    'description': 'Safe play zone for young kids',
    'image':
        'https://skyparkyercaud.in/wp-content/uploads/elementor/thumbs/WhatsApp-Image-2023-12-15-at-4.19.39-PM-scaled-qgufcrt3md8b4hcdnz07cm50naqs1bhzccrriufu24.jpeg',
    'longDescription':
        'Our colorful Soft Play Area provides the perfect entertainment zone for children under 8 years old. This carefully designed indoor playground features gentle slides, ball pits with thousands of colorful balls, climbing structures, sensory play walls, and soft obstacle courses all constructed with high-density foam and covered in easy-to-clean, soft-touch materials. Parents can relax in our adjacent seating area with complimentary Wi-Fi while maintaining clear visibility of their children at play. The entire facility is sanitized multiple times daily, and our attentive staff members are trained in child safety and first aid. A dedicated toddler corner ensures even the smallest guests have a safe space to explore and play.',
  },
  {
    'title': 'Kids Dirt Bike Adventure',
    'description': 'Mini dirt bikes on a guided track',
    'image':
        'https://skyparkyercaud.in/wp-content/uploads/elementor/thumbs/atv-ride-scaled-r2u07pvl394v9qx8c7rxiih8rr64avcedfq1p7igkw.jpeg',
    'longDescription':
        'Introduce your young riders to the exciting world of motorsports with our Kids Dirt Bike Adventure. We offer specially designed electric and small-engine dirt bikes for children aged 6-12, with different sizes available to match your child\'s height and experience level. Our beginner-friendly oval track features gentle berms and wide lanes, while more confident riders can progress to our intermediate track with small jumps and varied terrain. All necessary safety equipment is provided, including helmets, chest protectors, gloves, and knee pads. Each session begins with thorough instruction on bike controls and track etiquette, and our experienced instructors supervise all riding activities to ensure a safe and positive experience for young adventure seekers.',
  },
];

// Data for Water Activities
final List<Map<String, String>> waterActivities = [
  {
    'title': 'Kayaking & Canoeing',
    'description': 'Paddle through Yercaud\'s serene waters',
    'image':
        'https://cdn.pixabay.com/photo/2019/09/28/23/31/kayak-4511993_1280.jpg',
    'longDescription':
        'Discover the tranquil beauty of Yercaud\'s pristine lake as you glide across crystal-clear waters in our premium kayaks and canoes. Choose between stable sit-on-top kayaks perfect for beginners, sleek performance kayaks for those seeking speed, or traditional canoes ideal for couples and families. Each 90-minute session begins with expert instruction on paddling techniques and water safety. Follow our self-guided nature route marked with informational buoys highlighting local wildlife and plant species, or opt for a guided sunrise or sunset tour to experience the lake\'s magical transformation during golden hour. All equipment including paddles, life jackets, and dry bags is provided, and our lakeside launch area features changing rooms and lockers for your convenience.',
  },
  {
    'title': 'Water Zorbing',
    'description': 'Walk on water in an inflatable ball',
    'image':
        'https://d26dp53kz39178.cloudfront.net/media/uploads/products/zorbing_1.jpg',
    'longDescription':
        'Experience the unique sensation of walking on water in our transparent Water Zorbing balls. This fun activity places you inside a double-layered inflatable sphere with a cushion of air keeping you dry while you roll, walk, or attempt to run across our dedicated zorbing pool. Each session lasts for 15 thrilling minutes—plenty of time to master your balance and try different movements within the ball. Our experienced operators ensure your safety by controlling the inflation levels and assisting with entry and exit from the ball. Perfect for creating memorable vacation photos and videos, Water Zorbing combines the novelty of walking on water with plenty of laughs as you attempt to stay upright. Suitable for ages 7 and up with a maximum weight limit of 80kg per person.',
  },
  {
    'title': 'Infinity Pool Swimming',
    'description': 'Swim with valley views',
    'image':
        'https://cdn.pixabay.com/photo/2017/06/26/21/07/chiang-rai-2445218_1280.jpg',
    'longDescription':
        'Our spectacular infinity pool creates the illusion of swimming directly into Yercaud\'s majestic valley, with nothing but air between you and the panoramic landscape beyond. Heated to a perfect 28°C year-round, the pool features a seamless edge that appears to merge with the horizon, creating a truly immersive natural experience. The multi-level design includes shallow areas for children, comfortable in-water loungers, and a swim-up refreshment bar serving tropical drinks and light snacks. By night, subtle underwater lighting transforms the space into a magical evening retreat beneath the stars. Pool attendants provide plush towels and can arrange private swimming lessons or aqua fitness sessions upon request. Our infinity pool is exclusive to resort guests and day pass holders.',
  },
  {
    'title': 'Floating Breakfast Experience',
    'description': 'Gourmet breakfast in a private pool',
    'image':
        'https://images.unsplash.com/photo-1728051104796-a8c0f667cd90?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'longDescription':
        'Indulge in the ultimate luxury morning experience with our Instagram-worthy Floating Breakfast, served on a custom-designed floating tray in your private villa pool or our exclusive infinity pool. This culinary journey begins at your preferred time between 7:00 AM and 11:00 AM, when our dedicated butler silently prepares your floating feast while you relax. The gourmet spread includes freshly baked pastries, tropical fruit platters, made-to-order eggs, local specialties, premium coffee, fresh-pressed juices, and optional champagne. Your floating tray remains stable while you dip in and out of the water, enjoying your meal surrounded by the natural beauty of Yercaud. Professional photography services are available to capture this memorable experience, and special occasion packages can include flower decorations, personalized messages, or custom menu items.',
  },
];

// Data for Spa & Packages
final List<Map<String, String>> spaExperiences = [
  {
    'title': 'Misty Mountain Spa',
    'description': 'Panoramic view treatment rooms with signature massages',
    'image':
        'https://cdn.pixabay.com/photo/2022/02/25/21/36/spa-7034873_1280.jpg',
    'longDescription':
        'Perched on the edge of the mountain with floor-to-ceiling windows, our Misty Mountain Spa offers therapeutic treatments enhanced by breathtaking views of mist-covered valleys. Each of our six treatment suites features heated massage tables, private rainfall showers, and relaxation balconies where the cool mountain air complements your wellness journey. Our signature treatment, the "Shevaroy Spice Revival," incorporates locally sourced coffee, cinnamon, and clove oils in a 90-minute full-body massage designed to improve circulation and relieve muscle tension. All treatments begin with a warm herbal foot bath and include complimentary access to our aromatherapy steam room and outdoor hot spring pools. Our skilled therapists are trained in multiple modalities including Swedish, deep tissue, Thai, and Ayurvedic techniques, customizing each session to your specific needs.',
  },
  {
    'title': 'Lakeside Serenity Spa',
    'description': 'Relaxing treatments in overwater pavilions',
    'image':
        'https://cdn.pixabay.com/photo/2017/09/30/20/22/candles-2803444_1280.jpg',
    'longDescription':
        'Experience ultimate tranquility in our unique overwater treatment pavilions at Lakeside Serenity Spa, where the gentle sounds of rippling water enhance your relaxation journey. Each private pavilion extends over the calm waters of our lotus pond, with glass floor sections allowing you to observe koi fish swimming beneath you during your treatment. Our "Water Harmony" signature ritual begins with a mineral-rich blue lotus scrub, followed by a warm coconut oil massage and concludes with a hydrating facial using pure rosewater harvested from Yercaud\'s flower farms. The pavilions feature traditional thatched roofs that maintain cool temperatures naturally, and sliding bamboo walls that can be opened to embrace the lake breeze or closed for complete privacy. Arrive 30 minutes before your treatment to enjoy our herbal tea lounge and meditation dock extending into the water.',
  },
  {
    'title': 'Royal Shevaroy Spa Suite',
    'description': 'Private luxury spa suite with personalized service',
    'image':
        'https://cdn.pixabay.com/photo/2019/08/28/10/15/massage-4436373_1280.jpg',
    'longDescription':
        'For the ultimate in privacy and luxury, our Royal Shevaroy Spa Suite offers an exclusive sanctuary for couples or individuals seeking a premium wellness experience. This 1,200-square-foot private spa retreat features its own steam room, soaking tub for two, relaxation lounge, changing area, and dual treatment beds for simultaneous services. Your experience begins with a private consultation with our spa director to customize a series of treatments perfectly suited to your preferences and needs. The signature Royal Experience includes a coffee and vanilla body polish, warm herb pouch massage, gold-infused facial, and concludes with a private candlelit dinner served in your suite. Throughout your 4-hour journey, a dedicated spa butler ensures your comfort with refreshments, temperature control, music selection, and aromatherapy preferences, creating a truly personalized retreat.',
  },
];

final List<Map<String, String>> wellnessRetreats = [
  {
    'title': 'Mountain Awakening',
    'description': 'Daily yoga and meditation sessions with expert instructors',
    'image':
        'https://cdn.pixabay.com/photo/2017/03/26/21/54/yoga-2176668_1280.jpg',
    'longDescription':
        'Reconnect with yourself through our comprehensive Mountain Awakening program, designed to harness the natural energy of Yercaud\'s elevated landscape. Each day begins with sunrise yoga on our panoramic platform where the first light illuminates the valley below, followed by guided meditation sessions that utilize the mountain\'s natural acoustics to deepen your practice. Our expert instructors are certified in multiple yoga traditions including Hatha, Vinyasa, and Yin, allowing you to experience different approaches throughout your stay. The program includes daily breathing workshops, chakra balancing sessions, guided nature meditation walks, and evening sound healing ceremonies using traditional singing bowls. All classes accommodate beginners and advanced practitioners alike, with modifications offered to match your experience level. The retreat includes plant-based meals designed by our nutritionist to support your wellness journey.',
  },
  {
    'title': 'Detox & Rejuvenate',
    'description': 'Comprehensive 3-day wellness program for complete renewal',
    'image':
        'https://cdn.pixabay.com/photo/2017/01/20/17/25/detox-1995433_1280.jpg',
    'longDescription':
        'Our scientifically designed Detox & Rejuvenate program combines ancient wisdom with modern wellness approaches for a transformative 3-day experience. The journey begins with a thorough wellness assessment including body composition analysis and personalized consultation with our Ayurvedic doctor. Each day features a carefully sequenced program of cleansing therapies including dry brushing, herbal steam sessions, lymphatic drainage massage, and detoxifying body wraps using locally sourced clay and herbs. Your customized meal plan features organic, alkalizing foods prepared by our nutritionist chef, with cold-pressed juices and herbal infusions served throughout the day. The program includes daily guided activities such as forest bathing, mindful walking, and gentle yoga designed to support the body\'s natural cleansing processes. On your final day, you\'ll receive a personalized wellness plan to continue your health journey at home.',
  },
];
