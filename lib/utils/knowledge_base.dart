class GreenKnowledgeBase {
  // Main categories and their keywords
  static final Map<String, List<String>> categories = {
    'app': [
      'app',
      'application',
      'mobile',
      'download',
      'install',
      'update',
      'feature',
    ],
    'reports': [
      'report',
      'issue',
      'bug',
      'complaint',
      'complain',
      'problem',
      'crash',
      'error',
      'support',
      'help',
    ],
    'tracking': [
      'track',
      'tracking',
      'progress',
      'data',
      'log',
      'record',
      'monitor',
      'statistics',
      'analytics',
    ],
    'recycling': [
      'recycle',
      'recycling',
      'plastic',
      'paper',
      'glass',
      'metal',
      'bin',
      'waste',
      'trash',
      'dispose',
      'sort',
      'separate',
    ],
    'composting': [
      'compost',
      'food waste',
      'organic',
      'soil',
      'fertilizer',
      'kitchen waste',
      'biodegradable',
      'yard waste',
    ],
    'energy': [
      'energy',
      'electricity',
      'power',
      'solar',
      'wind',
      'save energy',
      'conserve',
      'bill',
      'electric',
      'light',
      'appliance',
    ],
    'water': [
      'water',
      'conserve',
      'save water',
      'shower',
      'tap',
      'leak',
      'rainwater',
      'harvest',
      'drought',
      'conservation',
    ],
    'transport': [
      'transport',
      'car',
      'bus',
      'bike',
      'walk',
      'electric vehicle',
      'ev',
      'public transport',
      'commute',
      'travel',
    ],
    'shopping': [
      'shop',
      'buy',
      'purchase',
      'product',
      'package',
      'plastic bag',
      'reusable',
      'sustainable',
      'eco-friendly',
      'organic',
    ],
    'food': [
      'food',
      'eat',
      'diet',
      'vegetarian',
      'vegan',
      'local',
      'organic',
      'waste food',
      'leftover',
      'grow',
      'garden',
    ],
    'general': [
      'green',
      'sustainable',
      'eco',
      'environment',
      'earth',
      'planet',
      'climate',
      'carbon',
      'footprint',
    ],
  };

  // Specialized responses for each category
  static final Map<String, List<String>> responses = {
    'app': [
      '''📱 **App Support**
      Having trouble with the app? Here are some quick introductions to get you started:
      1. Sign up and create your profile.
      2. Explore the main features: report issues, track progress, and provide feedback.
      3. Access chatbot (me!) for green lifestyle tips.
      For further assistance, visit our Help Center or contact support at @EcoTrackSupport

      We hope you enjoy using EcoTrack to make greener choices and maintain a sustainable lifestyle!
      ''',
    ],
    'reports': [
      '''🐞 **Reporting Issues**

      If you want to report any cleanliness or facilities issue, please follow these steps:
      1. Go to the 'Report Issue' section in the app menu.
      2. Describe the problem in detail, including the location and nature of the issue.
      3. Attach any relevant screenshots if possible.
      4. Submit your report.

      Our support team will review your submission and get back to you as soon as possible.
      I hope this helps!''',
    ],
    'tracking': [
      '''📊 **Tracking Your Progress**

      To track your environmental impact using the app, follow these steps:
      1. Navigate to the 'My Progress' section in the app.
      2. Here, you can view your report status, and historical data on the issues you've reported.
      3. Volunteer activities and their impact will also be displayed.

      Keep up the great work towards a greener lifestyle!''',
    ],
    'recycling': [
      '''♻️ **Recycling Guide**

**What to Recycle:**
✅ Paper & Cardboard (clean, dry)
✅ Plastic bottles (#1, #2, #5)
✅ Glass jars & bottles
✅ Metal cans & foil
✅ Cartons (milk, juice)

**Avoid:**
❌ Plastic bags & films
❌ Food-contaminated items
❌ Styrofoam
❌ Electronics
❌ Hazardous materials

**Tip:** Rinse containers before recycling!''',
      '''🔄 **Recycling Tips**

1. **Check local rules** - They vary by city
2. **Flatten cardboard** - Saves space
3. **Remove caps & lids** - Some need separate recycling
4. **No bagging recyclables** - They get tangled in machines
5. **When in doubt, throw it out** - Contamination ruins batches''',
    ],
    'composting': [
      '''🌱 **Composting 101**

**Green Materials (Nitrogen):**
• Fruit & vegetable scraps
• Coffee grounds & filters
• Tea bags (no staples)
• Fresh grass clippings
• Plant trimmings

**Brown Materials (Carbon):**
• Dry leaves
• Straw or hay
• Shredded paper
• Cardboard (small pieces)
• Sawdust (untreated wood)

**Avoid:**
• Meat & dairy
• Oily foods
• Pet waste
• Diseased plants
• Plastic/foil''',
      '''🏡 **Home Composting Tips**

**Simple Method:**
1. Choose a shaded spot
2. Layer greens & browns
3. Keep moist like a wrung-out sponge
4. Turn weekly for faster composting
5. Wait 2-6 months

**Benefits:**
• Reduces landfill waste by 30%
• Creates nutrient-rich soil
• Reduces need for chemical fertilizers''',
    ],
    'energy': [
      '''⚡ **Energy Saving Tips**

**Quick Wins:**
1. Switch to LED bulbs (saves 75% energy)
2. Unplug devices when not in use
3. Use power strips with switches
4. Lower thermostat by 1°C (saves 10%)
5. Wash clothes in cold water

**Big Impact:**
• Install solar panels
• Upgrade to Energy Star appliances
• Improve home insulation
• Use smart thermostat''',
      '''💡 **Smart Energy Habits**

**Lighting:**
• Use natural light when possible
• Install motion sensors
• Choose warm white LEDs (less blue light)

**Appliances:**
• Run full loads only
• Clean AC/refrigerator coils
• Defrost freezer regularly
• Use microwave instead of oven for small meals''',
    ],
    'water': [
      '''💧 **Water Conservation**

**Indoor Savings:**
• Take 5-minute showers
• Fix dripping taps immediately
• Install low-flow showerheads
• Only run full dishwasher loads
• Turn off tap while brushing

**Outdoor Savings:**
• Water plants early morning
• Use rain barrels
• Choose drought-tolerant plants
• Sweep instead of hosing
• Use mulch to retain moisture''',
      '''🌧️ **Water Wise Tips**

**In Bathroom:**
• Place a brick in toilet tank
• Collect shower water while warming up
• Turn off water while soaping

**In Kitchen:**
• Steam vegetables (uses less water)
• Defrost in fridge, not under running water
• Reuse cooking water for plants''',
    ],
    'transport': [
      '''🚲 **Sustainable Transport**

**Best Options:**
1. **Walking** - Zero emissions, healthy
2. **Cycling** - Fast, cheap, eco-friendly
3. **Public Transit** - Shared emissions
4. **Carpooling** - Share rides
5. **Electric Vehicles** - Cleaner option

**Tips:**
• Plan errands in one trip
• Maintain proper tire pressure
• Remove roof racks when not needed
• Use cruise control on highways''',
      '''🚗 **Green Driving Tips**

**Fuel Efficiency:**
• Drive at steady speeds
• Avoid rapid acceleration/braking
• Keep windows closed at high speeds
• Regular maintenance
• Remove excess weight from car

**EV Benefits:**
• Lower running costs
• Reduced emissions
• Less noise pollution
• Government incentives available''',
    ],
    'shopping': [
      '''🛍️ **Eco-Friendly Shopping**

**Before Buying:**
1. Do I really need this?
2. Can I borrow or buy second-hand?
3. Is it durable and repairable?
4. Is packaging minimal/recyclable?
5. Is it locally made?

**Green Choices:**
• Bring reusable bags
• Choose products with less packaging
• Support local businesses
• Buy in bulk when possible
• Avoid single-use plastics''',
      '''🌿 **Sustainable Products**

**Look For:**
• Recycled content
• Biodegradable materials
• Energy-efficient ratings
• Fair trade certification
• Organic certification

**Reduce Waste:**
• Use refillable containers
• Choose concentrates
• Repair instead of replace
• Donate or sell unused items''',
    ],
    'food': [
      '''🌽 **Sustainable Eating**

**Green Diet Tips:**
• Eat more plant-based meals
• Choose local & seasonal produce
• Reduce food waste
• Grow your own herbs/vegetables
• Support local farmers markets

**Food Waste Reduction:**
• Plan meals ahead
• Store food properly
• Use leftovers creatively
• Compost food scraps
• Understand expiration dates''',
      '''🍎 **Eco-Friendly Kitchen**

**Storage Tips:**
• Use beeswax wraps instead of plastic
• Store in glass containers
• Freeze leftovers
• Keep fruits & vegetables separate

**Cooking:**
• Cook in batches
• Use lids to cook faster
• Match pan size to burner
• Use residual heat''',
    ],
    'general': [
      '''🌍 **Green Lifestyle Basics**

**Daily Habits:**
• Reduce, Reuse, Recycle
• Conserve water & energy
• Choose sustainable transport
• Eat consciously
• Support green businesses

**Long-term Impact:**
• Plant trees
• Support environmental organizations
• Vote for green policies
• Educate others
• Lead by example''',
      '''💚 **Getting Started**

**Easy First Steps:**
1. Carry a reusable water bottle
2. Say no to plastic straws
3. Turn off lights when leaving room
4. Take shorter showers
5. Start recycling properly

**Remember:** Small changes make big differences over time!''',
    ],
    'greeting': [
      '''🌿 Hello! I'm your EcoTrack Assistant!

I can help you with:
♻️ **Recycling** - What goes where
🌱 **Composting** - Turn waste into gold
⚡ **Energy Saving** - Lower bills & emissions
💧 **Water Conservation** - Save this precious resource
🚲 **Sustainable Transport** - Green ways to travel
🛍️ **Eco Shopping** - Make better purchases
🌽 **Sustainable Food** - Eat green, live green
💡 **General Tips** - Everyday green living

What would you like to learn about today?''',
    ],
    'fallback': [
      '''🤔 I'm not sure about that specific topic, but here's some general green advice:

**Quick Green Tips:**
• Choose products with minimal packaging
• Turn off electronics at the wall
• Air dry clothes when possible
• Use both sides of paper
• Borrow instead of buy

Feel free to ask about specific green topics!''',
      '''🌱 I'm still learning about that area. Meanwhile, here's a simple green habit you can start today:

**Try this:** For one week, carry a reusable bag, bottle, and coffee cup everywhere you go. Notice how much single-use plastic you avoid!

Ask me about recycling, composting, energy saving, or other green topics.''',
    ],
  };

  // Special responses for specific keywords
  static final Map<String, String> keywordResponses = {
    'plastic bag': '''🛍️ **Plastic Bag Alternatives**

**Best Options:**
1. **Reusable cloth bags** - Durable, washable
2. **Mesh produce bags** - See-through, lightweight
3. **Paper bags** - Compostable, recyclable
4. **Baskets or boxes** - Great for market trips

**Remember:** A reusable bag needs to be used 50+ times to be more eco-friendly than plastic!''',
    'solar panel': '''☀️ **Solar Panels Guide**

**Benefits:**
• Reduces electricity bills
• Low carbon footprint
• Increases property value
• Works even on cloudy days
• Government incentives often available

**Considerations:**
• Upfront cost
• Roof orientation & shading
• Local regulations
• Battery storage options

**Tip:** Many companies offer solar leasing with no upfront cost!''',
    'electric car': '''⚡ **Electric Vehicles (EVs)**

**Advantages:**
• Lower running costs (electricity vs gas)
• Zero tailpipe emissions
• Less maintenance (no oil changes)
• Quiet operation
• Tax credits available

**Charging Options:**
• Home charging (overnight)
• Public charging stations
• Workplace charging
• Fast charging for long trips

**Range:** Most modern EVs get 200-300 miles per charge!''',
    'food waste': '''🍎 **Reducing Food Waste**

**Smart Shopping:**
• Make a meal plan
• Check fridge before shopping
• Buy imperfect produce
• Understand date labels:
  - "Best before" = quality, not safety
  - "Use by" = safety date

**Storage Tips:**
• Store potatoes & onions separately
• Keep bananas away from other fruits
• Freeze bread before it goes stale
• Store herbs in water like flowers''',
    'rainwater': '''🌧️ **Rainwater Harvesting**

**Simple System:**
1. Collect from roof gutters
2. Use first-flush diverter (removes debris)
3. Store in food-grade barrel
4. Use for gardening, washing cars, etc.

**Benefits:**
• Reduces water bills
• Plants love rainwater (no chlorine)
• Reduces stormwater runoff
• Conserves treated drinking water

**Safety:** Don't drink untreated rainwater!''',
  };

  // FAQ responses
  static final Map<String, String> faq = {
    'what is sustainability': '''🌍 **Sustainability Explained**

Sustainability means meeting our needs without compromising future generations' ability to meet theirs.

**Three Pillars:**
1. **Environmental** - Protect nature
2. **Social** - Support communities
3. **Economic** - Ensure fair prosperity

**In practice:** Using renewable resources, reducing waste, and creating equitable systems.''',
    'why go green': '''💚 **Benefits of Going Green**

**For You:**
• Save money on bills
• Healthier lifestyle
• Less clutter & waste
• Peace of mind

**For Community:**
• Cleaner air & water
• Stronger local economy
• Better public health
• Green job creation

**For Planet:**
• Reduced climate change
• Protected ecosystems
• Preserved resources
• Biodiversity conservation''',
    'how start green lifestyle': '''🌱 **Getting Started Guide**

**Week 1-2:** Awareness
• Track your waste for a week
• Calculate your carbon footprint
• Identify biggest environmental impacts

**Week 3-4:** Easy Changes
• Switch to LED bulbs
• Use reusable bags & bottles
• Start recycling properly
• Take shorter showers

**Month 2:** Bigger Steps
• Start composting
• Reduce meat consumption
• Use public transport more
• Buy second-hand items''',
    'best eco friendly products': '''🛍️ **Top Eco-Friendly Products**

**Essentials:**
1. Reusable water bottle
2. Cloth shopping bags
3. Beeswax food wraps
4. Safety razor (instead of disposable)
5. Bamboo toothbrush
6. Menstrual cup/reusable pads
7. Compost bin
8. LED light bulbs
9. Water-saving showerhead
10. Reusable coffee cup

**Tip:** Use what you have first before buying new!''',
    'how reduce carbon footprint': '''👣 **Reducing Carbon Footprint**

**High Impact Actions:**
1. **Transport:** Walk/bike, use public transit, fly less
2. **Home:** Switch to green energy, improve insulation
3. **Diet:** Eat plant-based, reduce food waste
4. **Shopping:** Buy less, choose local, avoid fast fashion
5. **Energy:** Unplug devices, use efficient appliances

**Calculate:** Use online carbon footprint calculators!''',
  };

  // Check if message matches any FAQ
  static String? getFAQResponse(String message) {
    final lowerMessage = message.toLowerCase();

    for (final faqKey in faq.keys) {
      if (lowerMessage.contains(faqKey.toLowerCase())) {
        return faq[faqKey];
      }
    }
    return null;
  }

  // Check for keyword-specific responses
  static String? getKeywordResponse(String message) {
    final lowerMessage = message.toLowerCase();

    for (final keyword in keywordResponses.keys) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        return keywordResponses[keyword];
      }
    }
    return null;
  }

  // Categorize message and get response
  static String categorizeAndRespond(String message) {
    final lowerMessage = message.toLowerCase();

    // Check FAQ first
    final faqResponse = getFAQResponse(lowerMessage);
    if (faqResponse != null) return faqResponse;

    // Check keyword responses
    final keywordResponse = getKeywordResponse(lowerMessage);
    if (keywordResponse != null) return keywordResponse;

    // Check greetings
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey') ||
        lowerMessage.contains('start')) {
      return responses['greeting']![0];
    }

    // Find matching category
    String matchedCategory = 'general';
    int maxMatches = 0;

    for (final category in categories.keys) {
      int matches = 0;
      for (final keyword in categories[category]!) {
        if (lowerMessage.contains(keyword)) {
          matches++;
        }
      }

      if (matches > maxMatches) {
        maxMatches = matches;
        matchedCategory = category;
      }
    }

    // Get random response from category
    final categoryResponses =
        responses[matchedCategory] ?? responses['general']!;
    final randomIndex = DateTime.now().millisecond % categoryResponses.length;

    return categoryResponses[randomIndex];
  }
}
