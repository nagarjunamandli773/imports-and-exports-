/**
 * CONCEPT EXIM - Live Consignment & Cargo Telemetry Tracking Engine (tracking.js)
 * Real-time AIS Satellite Telemetry, IceGate Customs, IoT Cold-Chain & Interactive Voyage Map
 */

(function () {
  'use strict';

  // 1. Comprehensive Consignment Database with Nautical Routes & Vector Coordinates
  const CONSIGNMENT_DB = {
    'SHP-2025-0891': {
      id: 'SHP-2025-0891',
      blNumber: 'MSK-IN-9920147',
      bookingRef: 'BKG-MUM-89104',
      commodity: 'Organic Basmati Rice (Grade 1121 Super Extra)',
      hsCode: '1006.30.20',
      volume: '24 Metric Tons (1 × 40ft High Cube Container)',
      originPort: 'Mundra Port (INMUN1)',
      originCity: 'Gujarat',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'Port of Rotterdam (NLRTM)',
      destCity: 'Rotterdam',
      destCountry: 'Netherlands',
      destFlag: '🇳🇱',
      carrier: 'Maersk Ocean Line',
      carrierCode: 'MAEU',
      vesselName: 'Maersk Mc-Kinney Møller',
      vesselImo: 'IMO 9619907',
      vesselMmsi: '219018271',
      vesselFlag: 'Denmark (DIS)',
      callSign: 'OWQZ2',
      status: 'In Transit (High Seas)',
      statusClass: 'status-in-transit',
      statusIcon: 'fa-ship',
      progress: 72,
      departureDate: 'Apr 26, 2025 • 06:30 IST',
      eta: 'May 14, 2025 • 18:00 CEST (On Schedule)',
      coordinates: '23.412° N, 64.821° E',
      speed: '19.4 Knots',
      heading: '284° WNW',
      seaState: 'Sea State 2 (Smooth Wavelet, 0.4m)',
      containerNo: 'MSKU-829104-2',
      containerType: '40ft High Cube (Steel)',
      customsSealNo: 'IN-CUS-881290',
      tareWeight: '3,840 KG',
      grossWeight: '27,840 KG',
      temperature: '+21.5°C Controlled Venting',
      tempPercent: 42,
      humidity: '54% RH (Optimal Grain Grade)',
      humidityPercent: 54,
      shockSensor: 'Normal (0.02G Logged)',
      incoterm: 'CIF Rotterdam (Incoterms 2020)',
      insurancePolicy: 'OIC-9921-MAR-A1 (All-Risk Ocean Cover)',
      iceGateSbNo: 'SB-2025-449102 (Dated: Apr 24, 2025)',
      iceGateStatus: 'LEO Issued (Let Export Order Cleared)',
      certifications: 'APEDA Export Permit #AP-9921 • FSSAI Certified',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry
      geoOrigin: [22.7383, 69.7042], // Mundra Port
      geoDest: [51.9500, 4.1400],    // Rotterdam Port
      geoVessel: [20.4500, 64.2000],  // Arabian Sea High Seas
      geoRoute: [
        [22.7383, 69.7042],
        [21.8000, 68.5000],
        [20.4500, 64.2000],
        [16.5000, 56.0000],
        [12.8000, 48.0000],
        [12.6000, 43.4000],
        [18.5000, 39.5000],
        [27.8000, 34.2000],
        [29.9300, 32.5500],
        [31.2600, 32.3100],
        [34.5000, 24.5000],
        [36.8000, 13.5000],
        [37.2000, 2.5000],
        [35.9500, -5.6000],
        [40.0000, -9.8000],
        [44.5000, -8.5000],
        [49.8000, -4.5000],
        [50.5000, -0.5000],
        [51.2000, 1.9000],
        [51.9500, 4.1400]
      ],
      distanceTotal: '6,660 Nautical Miles',
      distanceSailed: '4,795 NM Sailed (72%)',
      distanceRemaining: '1,865 NM Remaining',
      satellitePing: '38 ms • Inmarsat-C Lock',
      milestones: [
        {
          title: 'Export Contract & Phytosanitary Audit',
          time: 'Apr 22, 2025 • 14:00 IST',
          desc: 'APEDA laboratory sample tested and approved. 100% aflatoxin and moisture clearance verified.',
          location: 'Gandhidham Inland Testing CFS',
          completed: true
        },
        {
          title: 'Container Stuffing & Customs Sealing',
          time: 'Apr 24, 2025 • 11:30 IST',
          desc: 'Container MSKU-829104-2 stuffed with 24 MT palletized cargo and sealed under Central Excise supervision.',
          location: 'Adani Logistics Park, Mundra',
          completed: true
        },
        {
          title: 'Mundra Port Loading & Ocean Departure',
          time: 'Apr 26, 2025 • 06:30 IST',
          desc: 'Vessel Maersk Mc-Kinney Møller cast off from Berth #4. e-BL MSK-IN-9920147 released.',
          location: 'Mundra Port Marine Terminal (INMUN1)',
          completed: true
        },
        {
          title: 'Arabian Sea / Suez Maritime Corridor',
          time: 'Live Telemetry Active • Satellite Sync',
          desc: 'Vessel underway at 19.4 Knots. AIS telemetry transmitted via Inmarsat-C satellite link.',
          location: 'Coordinates 23.412° N, 64.821° E',
          active: true
        },
        {
          title: 'Rotterdam Port Inward Berth & Doorstep Delivery',
          time: 'Expected: May 14, 2025 • 18:00 CEST',
          desc: 'Discharge at APM Terminals Rotterdam. EU customs declaration and bonded transit scheduled.',
          location: 'Port of Rotterdam (NLRTM), Netherlands',
          upcoming: true
        }
      ]
    },

    'SHP-2025-0890': {
      id: 'SHP-2025-0890',
      blNumber: 'HAP-DXB-55102',
      bookingRef: 'BKG-JNPT-44019',
      commodity: 'Guntur Teja Red Chilli & Whole Spices Assortment',
      hsCode: '0904.21.10',
      volume: '14 Metric Tons (1 × 20ft FCL Container)',
      originPort: 'JNPT Nhava Sheva (INNSA1)',
      originCity: 'Navi Mumbai',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'Jebel Ali Port (AEJEA)',
      destCity: 'Dubai',
      destCountry: 'UAE',
      destFlag: '🇦🇪',
      carrier: 'Hapag-Lloyd Global',
      carrierCode: 'HLCU',
      vesselName: 'Al-Jubail Express',
      vesselImo: 'IMO 9732104',
      vesselMmsi: '470129000',
      vesselFlag: 'UAE',
      callSign: 'A6DXB',
      status: 'Customs Pre-Cleared (Approaching Berth)',
      statusClass: 'status-cleared',
      statusIcon: 'fa-clipboard-check',
      progress: 92,
      departureDate: 'May 01, 2025 • 22:15 IST',
      eta: 'May 07, 2025 • 10:00 GST (Approaching Pilot Station)',
      coordinates: '25.018° N, 55.059° E',
      speed: '11.8 Knots',
      heading: '195° SSW',
      seaState: 'Calm Sea (0.2m Swell)',
      containerNo: 'HLXU-410982-9',
      containerType: '20ft General Purpose (FCL)',
      customsSealNo: 'IN-CUS-774011',
      tareWeight: '2,200 KG',
      grossWeight: '16,200 KG',
      temperature: 'Ambient Desiccant Monitored (+28°C)',
      tempPercent: 55,
      humidity: '42% RH (Moisture Barrier Liners Active)',
      humidityPercent: 42,
      shockSensor: 'Normal (Inspected)',
      incoterm: 'CIF Jebel Ali (Incoterms 2020)',
      insurancePolicy: 'NIA-5510-CAR-B2 (Marine Open Policy)',
      iceGateSbNo: 'SB-2025-448910 (Dated: Apr 30, 2025)',
      iceGateStatus: 'LEO Cleared & Mirsal II Customs Verified',
      certifications: 'Spices Board of India Certificate #SB-88210',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry
      geoOrigin: [18.9500, 72.9500], // JNPT Nhava Sheva
      geoDest: [25.0180, 55.0590],   // Jebel Ali Port Dubai
      geoVessel: [24.8500, 55.4000], // Approaching Pilot Station
      geoRoute: [
        [18.9500, 72.9500],
        [19.5000, 71.0000],
        [21.5000, 66.0000],
        [23.5000, 60.5000],
        [24.5000, 58.0000],
        [25.8000, 56.8000],
        [26.2000, 56.4000],
        [25.5000, 55.8000],
        [24.8500, 55.4000],
        [25.0180, 55.0590]
      ],
      distanceTotal: '1,050 Nautical Miles',
      distanceSailed: '966 NM Sailed (92%)',
      distanceRemaining: '84 NM Remaining',
      satellitePing: '24 ms • Low Latency Gulf Link',
      milestones: [
        {
          title: 'Spices Board Quality Audit & Packaging',
          time: 'Apr 28, 2025 • 10:00 IST',
          desc: 'Capsaicin potency, color value (ASTA), and moisture analysis certified.',
          location: 'Spices Board Quality Lab, Mumbai',
          completed: true
        },
        {
          title: 'JNPT CFS Gate-In & Container Stacking',
          time: 'Apr 30, 2025 • 16:30 IST',
          desc: 'Direct Port Entry (DPE) clearance achieved at Nhava Sheva Gateway Terminal.',
          location: 'JNPT Marine Berth #2 (INNSA1)',
          completed: true
        },
        {
          title: 'Arabian Gulf Sea Passage',
          time: 'May 02 - May 05, 2025',
          desc: 'Vessel navigated direct Mumbai-Dubai sea lane at average 17 knots.',
          location: 'Strait of Hormuz Corridor',
          completed: true
        },
        {
          title: 'Dubai Mirsal II Customs Pre-Clearance',
          time: 'Live Now • Gate Inspection Verified',
          desc: 'Dubai Customs electronic pre-declaration cleared with zero demurrage hold.',
          location: 'Jebel Ali Terminal 1 (AEJEA)',
          active: true
        },
        {
          title: 'Consignee Warehouse Delivery (Al Aweer)',
          time: 'Expected: May 07, 2025 • 16:00 GST',
          desc: 'Bonded flatbed truck dispatch to buyer food logistics hub in Dubai.',
          location: 'Al Aweer Industrial Trade Zone, Dubai',
          upcoming: true
        }
      ]
    },

    'SHP-2025-0889': {
      id: 'SHP-2025-0889',
      blNumber: 'CMA-HAM-88412',
      bookingRef: 'BKG-CHE-11928',
      commodity: 'Tier-1 Bifacial Solar PV Modules & Inverters',
      hsCode: '8541.40.11',
      volume: '48 Metric Tons (2 × 40ft High Cube Containers)',
      originPort: 'Chennai Port (INMAA1)',
      originCity: 'Chennai',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'Port of Hamburg (DEHAM)',
      destCity: 'Hamburg',
      destCountry: 'Germany',
      destFlag: '🇩🇪',
      carrier: 'CMA CGM Ocean Group',
      carrierCode: 'CMDU',
      vesselName: 'CMA CGM Antoine de Saint Exupéry',
      vesselImo: 'IMO 9776418',
      vesselMmsi: '228339700',
      vesselFlag: 'France',
      callSign: 'FNMA',
      status: 'In Transit (Bab-el-Mandeb Strait)',
      statusClass: 'status-in-transit',
      statusIcon: 'fa-ship',
      progress: 65,
      departureDate: 'Apr 28, 2025 • 18:00 IST',
      eta: 'May 19, 2025 • 14:00 CEST (On Schedule)',
      coordinates: '12.184° N, 44.029° E',
      speed: '18.2 Knots',
      heading: '312° NW',
      seaState: 'Sea State 3 (Moderate, 1.1m)',
      containerNo: 'CMAU-619204-1 / CMAU-619205-7',
      containerType: '40ft HC Industrial High Cube',
      customsSealNo: 'IN-CUS-663819',
      tareWeight: '7,680 KG (2 Units)',
      grossWeight: '55,680 KG Total',
      temperature: 'Ambient Temperature (+24.0°C)',
      tempPercent: 48,
      humidity: '48% RH Monitored',
      humidityPercent: 48,
      shockSensor: 'Impact G-Force < 0.2G (Normal)',
      incoterm: 'DDP Hamburg (Incoterms 2020)',
      insurancePolicy: 'TATA-8841-GLO (Industrial Equipment Policy)',
      iceGateSbNo: 'SB-2025-447819 (Dated: Apr 26, 2025)',
      iceGateStatus: 'LEO Cleared & CE Compliant',
      certifications: 'TÜV Rheinland IEC 61215 / CE Certified',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry
      geoOrigin: [13.0827, 80.2707], // Chennai Port
      geoDest: [53.5350, 9.9700],    // Port of Hamburg
      geoVessel: [12.1840, 44.0290], // Bab-el-Mandeb Strait
      geoRoute: [
        [13.0827, 80.2707],
        [8.0000, 80.0000],
        [5.8000, 79.5000],
        [7.0000, 74.0000],
        [10.5000, 65.0000],
        [12.1840, 44.0290],
        [12.6000, 43.4000],
        [19.0000, 39.0000],
        [27.8000, 34.2000],
        [29.9300, 32.5500],
        [31.2600, 32.3100],
        [34.5000, 24.5000],
        [36.8000, 13.5000],
        [35.9500, -5.6000],
        [44.0000, -8.5000],
        [49.5000, -3.5000],
        [51.2000, 1.9000],
        [53.8000, 5.0000],
        [53.9500, 8.7000],
        [53.5350, 9.9700]
      ],
      distanceTotal: '7,150 Nautical Miles',
      distanceSailed: '4,647 NM Sailed (65%)',
      distanceRemaining: '2,503 NM Remaining',
      satellitePing: '45 ms • Maritime Fleet Broadband',
      milestones: [
        {
          title: 'Factory Quality Assurance & Flash Test',
          time: 'Apr 24, 2025 • 09:00 IST',
          desc: 'EL and Flash test reports archived with individual serial number verification.',
          location: 'Chennai Special Economic Zone',
          completed: true
        },
        {
          title: 'Chennai Port Container Loading',
          time: 'Apr 28, 2025 • 18:00 IST',
          desc: 'Twin 40ft containers lifted aboard CMA CGM mother vessel via STS gantry.',
          location: 'Chennai Port Container Terminal (INMAA1)',
          completed: true
        },
        {
          title: 'Bab-el-Mandeb Strait Passage',
          time: 'Live Telemetry Active • Red Sea Corridor',
          desc: 'Vessel underway at 18.2 Knots escorted in international maritime security lane.',
          location: 'Coordinates 12.184° N, 44.029° E',
          active: true
        },
        {
          title: 'Suez Canal Convoy Transit',
          time: 'Expected: May 09, 2025 • 04:00 UTC',
          desc: 'Northbound convoy booking confirmed with Suez Canal Authority.',
          location: 'Port Said Gateway, Egypt',
          upcoming: true
        },
        {
          title: 'Hamburg Port Discharge & DDP Warehouse Delivery',
          time: 'Expected: May 19, 2025 • 14:00 CEST',
          desc: 'Discharge at Container Terminal Altenwerder (CTA) & heavy haulage dispatch.',
          location: 'Port of Hamburg (DEHAM), Germany',
          upcoming: true
        }
      ]
    },

    'SHP-2025-0888': {
      id: 'SHP-2025-0888',
      blNumber: 'MSC-NYC-77192',
      bookingRef: 'BKG-CCU-99210',
      commodity: 'Organic Combed Cotton Yarns & Apparel Textiles',
      hsCode: '5205.22.00',
      volume: '36 Metric Tons (2 × 40ft High Cube)',
      originPort: 'Kolkata Port (INCCU1)',
      originCity: 'Kolkata',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'Port of New York & New Jersey',
      destCity: 'New York',
      destCountry: 'United States',
      destFlag: '🇺🇸',
      carrier: 'MSC Mediterranean Shipping',
      carrierCode: 'MSCU',
      vesselName: 'MSC Isabella',
      vesselImo: 'IMO 9839284',
      vesselMmsi: '354628000',
      vesselFlag: 'Panama',
      callSign: '3FRO9',
      status: 'Port Marine Terminal Stacking',
      statusClass: 'status-loading',
      statusIcon: 'fa-boxes-stacked',
      progress: 28,
      departureDate: 'May 06, 2025 • Expected 20:00 IST',
      eta: 'May 28, 2025 • 08:00 EDT (Atlantic Passage)',
      coordinates: '22.572° N, 88.363° E',
      speed: 'At Berth Terminal (Dock 4)',
      heading: 'Moored (000°)',
      seaState: 'Port Basin Calm',
      containerNo: 'MEDU-992147-0 / MEDU-992148-5',
      containerType: '40ft HC Moisture-Sealed Textile Grade',
      customsSealNo: 'IN-CUS-551982',
      tareWeight: '7,700 KG (2 Units)',
      grossWeight: '43,700 KG Total',
      temperature: 'Ambient Dry Silica Protected (+27°C)',
      tempPercent: 54,
      humidity: '40% RH (Zero Mold Risk)',
      humidityPercent: 40,
      shockSensor: 'Normal',
      incoterm: 'CIF New York (Incoterms 2020)',
      insurancePolicy: 'BAG-7719-NYC (All-Risk Marine Textile Policy)',
      iceGateSbNo: 'SB-2025-446912 (Dated: May 02, 2025)',
      iceGateStatus: 'LEO Cleared & US CBP ACE Pre-Filed',
      certifications: 'GOTS Organic Fibre Certificate #GOTS-9941',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry
      geoOrigin: [22.5400, 88.3100], // Kolkata Port
      geoDest: [40.6700, -74.1200],  // Port of New York & New Jersey
      geoVessel: [22.5400, 88.3100], // Kolkata Berth Loading
      geoRoute: [
        [22.5400, 88.3100],
        [20.5000, 88.5000],
        [15.0000, 85.0000],
        [6.0000, 80.5000],
        [5.5000, 77.0000],
        [10.0000, 65.0000],
        [12.6000, 43.4000],
        [20.0000, 38.5000],
        [30.0000, 32.5000],
        [35.0000, 20.0000],
        [36.5000, 5.0000],
        [35.9500, -5.6000],
        [36.5000, -15.0000],
        [38.0000, -35.0000],
        [39.5000, -55.0000],
        [40.2000, -68.0000],
        [40.6700, -74.1200]
      ],
      distanceTotal: '8,400 Nautical Miles',
      distanceSailed: '2,352 NM Sailed (28%)',
      distanceRemaining: '6,048 NM Remaining',
      satellitePing: '52 ms • Terminal Wi-Fi & Iridium',
      milestones: [
        {
          title: 'GOTS Organic Fibre Audit & Moisture Check',
          time: 'May 01, 2025 • 11:00 IST',
          desc: 'Global Organic Textile Standard validation completed. 100% organic cotton certified.',
          location: 'Texprocil Accredited Laboratory, Kolkata',
          completed: true
        },
        {
          title: 'Kolkata Port Marine Terminal Stacking',
          time: 'Live Now • Berth 4 Gantry Crane Stacking',
          desc: 'Containers transferred into shipside loading queue for vessel MSC Isabella.',
          location: 'Netaji Subhas Dock, Kolkata (INCCU1)',
          active: true
        },
        {
          title: 'Vessel Departure & Bay of Bengal Passage',
          time: 'Scheduled: May 06, 2025 • 20:00 IST',
          desc: 'Pilot boarded for Hugli river navigation down to Sandheads sea lane.',
          location: 'Bay of Bengal Deep Sea Route',
          upcoming: true
        },
        {
          title: 'Trans-Atlantic Ocean Corridor',
          time: 'Expected: May 16 - May 24, 2025',
          desc: 'Passage via Mediterranean & Atlantic transit routes.',
          location: 'North Atlantic Ocean Transit',
          upcoming: true
        },
        {
          title: 'US CBP Clearance & NY Port Discharge',
          time: 'Expected: May 28, 2025 • 08:00 EDT',
          desc: 'Discharge at Port Newark Container Terminal (PNCT) for customer distribution.',
          location: 'Port of New York & New Jersey, USA',
          upcoming: true
        }
      ]
    },

    'SHP-2025-0887': {
      id: 'SHP-2025-0887',
      blNumber: 'EK-LON-33019',
      bookingRef: 'BKG-AIR-AMD-771',
      commodity: 'Active Pharmaceutical Ingredients (API) & Salts',
      hsCode: '2933.39.90',
      volume: '8.5 Metric Tons (Temperature-Controlled Envirotainer)',
      originPort: 'Sardar Vallabhbhai Patel Air Cargo (INAMD)',
      originCity: 'Ahmedabad',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'London Heathrow Cargo Terminal (GBLHR)',
      destCity: 'London',
      destCountry: 'United Kingdom',
      destFlag: '🇬🇧',
      carrier: 'Emirates SkyCargo Priority',
      carrierCode: 'UAE-AIR',
      vesselName: 'Boeing 777-F Cargo (Flight EK-9821)',
      vesselImo: 'Reg: A6-EFG (Aircraft)',
      vesselMmsi: 'ICAO 896328',
      vesselFlag: 'UAE Aviation',
      callSign: 'UAE9821',
      status: 'Customs Cleared & Pre-Dispatched',
      statusClass: 'status-cleared',
      statusIcon: 'fa-plane-circle-check',
      progress: 85,
      departureDate: 'May 04, 2025 • 04:30 IST',
      eta: 'May 06, 2025 • 15:30 BST (Priority Flight)',
      coordinates: '51.470° N, 0.454° W',
      speed: '490 Knots (Cruising Speed)',
      heading: 'Altitude 34,000 FT',
      seaState: 'N/A (Airfreight Express)',
      containerNo: 'EK-RAP-99120 (Envirotainer RAP e2)',
      containerType: 'Active Temperature Pharma Container',
      customsSealNo: 'AIR-CUS-99128',
      tareWeight: '1,120 KG',
      grossWeight: '9,620 KG Total',
      temperature: '+4.2°C Continuous Cold Chain (+2°C to +8°C)',
      tempPercent: 20,
      humidity: '45% RH Monitored',
      humidityPercent: 45,
      shockSensor: 'Zero Deviation Logged',
      incoterm: 'CPT London Heathrow (Incoterms 2020)',
      insurancePolicy: 'AIR-PHARMA-9912 (High-Value Pharma Cover)',
      iceGateSbNo: 'SB-2025-445812 (Dated: May 03, 2025)',
      iceGateStatus: 'Air Cargo LEO Granted & CDSCO Cleared',
      certifications: 'WHO-GMP & UK MHRA Compliance Verified',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry (Aviation Corridor)
      geoOrigin: [23.0726, 72.6347], // SVPIA Air Cargo Terminal, Ahmedabad
      geoDest: [51.4700, -0.4543],   // London Heathrow Airport
      geoVessel: [51.2000, 0.5000],  // Approach Waypoint London Airspace
      geoRoute: [
        [23.0726, 72.6347],
        [24.5000, 65.0000],
        [25.2500, 55.3600],
        [30.0000, 45.0000],
        [35.0000, 35.0000],
        [42.0000, 20.0000],
        [48.0000, 8.0000],
        [51.2000, 0.5000],
        [51.4700, -0.4543]
      ],
      distanceTotal: '4,220 Nautical Miles',
      distanceSailed: '3,587 NM Flown (85%)',
      distanceRemaining: '633 NM Remaining',
      satellitePing: '18 ms • Aviation ACARS Link',
      milestones: [
        {
          title: 'Pharma Batch QC & Temperature Logger Activation',
          time: 'May 02, 2025 • 15:00 IST',
          desc: 'Continuous digital datalogger activated; dual sensor probe calibrated to ±0.1°C.',
          location: 'Ahmedabad Pharma Special Economic Zone',
          completed: true
        },
        {
          title: 'Ahmedabad Air Cargo Hub LEO Clearance',
          time: 'May 03, 2025 • 21:00 IST',
          desc: 'Special customs drug controller clearance granted under EDI IceGate.',
          location: 'SVPIA Air Cargo Terminal (INAMD)',
          completed: true
        },
        {
          title: 'Airfreight Flight EK-9821 Departure',
          time: 'May 04, 2025 • 04:30 IST',
          desc: 'Airway Bill EK-LON-33019 validated and cargo palletized into temperature vault.',
          location: 'Boeing 777-F Cargo Hold',
          completed: true
        },
        {
          title: 'London Heathrow Cold-Room Handling',
          time: 'Live Now • Heathrow World Cargo Center Vault',
          desc: 'Shipment docked in GDP-certified cool room (+2°C to +8°C). UK MHRA filing cleared.',
          location: 'Heathrow Airport Cargo Terminal (GBLHR), UK',
          active: true
        },
        {
          title: 'Dedicated Reefer Van Hospital Delivery',
          time: 'Expected: May 06, 2025 • 15:30 BST',
          desc: 'Temperature-monitored refrigerated van delivery to NHS clinical depot.',
          location: 'London Medical Trade Center, UK',
          upcoming: true
        }
      ]
    },

    'SHP-2025-0886': {
      id: 'SHP-2025-0886',
      blNumber: 'PIL-SIN-11048',
      bookingRef: 'BKG-MUN-33109',
      commodity: 'Cold-Pressed Organic Sesame Seed Oil (Food Grade)',
      hsCode: '1515.50.91',
      volume: '21 Metric Tons (1 × 20ft ISO Flexitank)',
      originPort: 'Mundra Port (INMUN1)',
      originCity: 'Gujarat',
      originCountry: 'India',
      originFlag: '🇮🇳',
      destPort: 'Port of Singapore (SGSIN)',
      destCity: 'Singapore',
      destCountry: 'Singapore',
      destFlag: '🇸🇬',
      carrier: 'Pacific International Lines (PIL)',
      carrierCode: 'PILU',
      vesselName: 'Kota Cantik',
      vesselImo: 'IMO 9607831',
      vesselMmsi: '566089000',
      vesselFlag: 'Singapore',
      callSign: '9V8812',
      status: 'In Transit (Malacca Strait Corridor)',
      statusClass: 'status-in-transit',
      statusIcon: 'fa-ship',
      progress: 48,
      departureDate: 'May 02, 2025 • 14:00 IST',
      eta: 'May 11, 2025 • 22:00 SGT (On Schedule)',
      coordinates: '05.892° N, 95.120° E',
      speed: '16.5 Knots',
      heading: '124° ESE',
      seaState: 'Sea State 2 (Gentle Swell, 0.6m)',
      containerNo: 'PILU-772810-3',
      containerType: '20ft ISO Food-Grade Flexitank Unit',
      customsSealNo: 'IN-CUS-331092',
      tareWeight: '2,400 KG',
      grossWeight: '23,400 KG Total',
      temperature: 'Ambient Nitrogen Blanketed (+26°C)',
      tempPercent: 52,
      humidity: 'N/A (Liquid Bulk in Multi-Layer Polyethylene)',
      humidityPercent: 25,
      shockSensor: 'Zero Flex Stress Logged',
      incoterm: 'FOB Mundra / CFR Singapore (Incoterms 2020)',
      insurancePolicy: 'UIIC-1104-MAR-F1 (Liquid Cargo Cover)',
      iceGateSbNo: 'SB-2025-444912 (Dated: Apr 30, 2025)',
      iceGateStatus: 'LEO Cleared & FSSAI Export Certified',
      certifications: 'USDA Organic & Singapore SFA Pre-Approved',
      // Geographic Maritime Coordinates for Interactive Leaflet Telemetry
      geoOrigin: [22.7383, 69.7042], // Mundra Port
      geoDest: [1.2644, 103.8200],   // Port of Singapore
      geoVessel: [5.8920, 95.1200],  // Malacca Strait Approach
      geoRoute: [
        [22.7383, 69.7042],
        [18.0000, 71.0000],
        [11.0000, 73.5000],
        [7.5000, 78.5000],
        [5.8000, 81.5000],
        [5.5000, 89.0000],
        [5.8920, 95.1200],
        [4.0000, 98.5000],
        [2.5000, 101.5000],
        [1.3000, 103.5000],
        [1.2644, 103.8200]
      ],
      distanceTotal: '2,420 Nautical Miles',
      distanceSailed: '1,161 NM Sailed (48%)',
      distanceRemaining: '1,259 NM Remaining',
      satellitePing: '34 ms • Indian Ocean C-Band',
      milestones: [
        {
          title: 'Cold-Press Extraction & Flexitank Fitting',
          time: 'Apr 28, 2025 • 11:30 IST',
          desc: 'High-tensile flexitank installed in 20ft container with corrugated bulkhead.',
          location: 'Rajkot Edible Oil Export Facility',
          completed: true
        },
        {
          title: 'Mundra Port Loading on Vessel Kota Cantik',
          time: 'May 02, 2025 • 14:00 IST',
          desc: 'Loaded into midship tier container bay for maximum stability.',
          location: 'Mundra Port Container Terminal (INMUN1)',
          completed: true
        },
        {
          title: 'Andaman Sea & Malacca Strait Corridor',
          time: 'Live Telemetry Active • Satellite Tracked',
          desc: 'Vessel underway at 16.5 Knots approaching Northern Sumatra waypoint.',
          location: 'Coordinates 05.892° N, 95.120° E',
          active: true
        },
        {
          title: 'Singapore Western Anchorage Arrival',
          time: 'Expected: May 11, 2025 • 22:00 SGT',
          desc: 'Pilotage booking confirmed for Jurong Port liquid terminal discharge.',
          location: 'Port of Singapore (SGSIN)',
          upcoming: true
        },
        {
          title: 'Direct Pumping into Buyer Storage Silo',
          time: 'Expected: May 12, 2025 • 10:00 SGT',
          desc: 'Sanitary pumping hose discharge into Tuas food processing silos.',
          location: 'Tuas Industrial Edible Oils Facility, Singapore',
          upcoming: true
        }
      ]
    }
  };

  // 2. Main Tracking Console Controller
  const TrackingApp = {
    currentId: 'SHP-2025-0891',
    mapMode: 'satellite', // 'satellite', 'nautical', 'radar'
    simulating: true,
    pingInterval: null,
    leafletMap: null,
    tileLayers: {},
    currentLayer: null,
    mapMarkers: {
      origin: null,
      dest: null,
      vessel: null,
      routeGlow: null,
      routeLead: null,
      waypoints: []
    },

    init: function () {
      this.initLeafletMap();
      this.bindEvents();
      this.checkUrlParams();
      this.render(this.currentId);
      this.startLiveSimulation();
    },

    initLeafletMap: function () {
      const container = document.getElementById('leafletLiveMap');
      if (!container) return;

      if (typeof L === 'undefined') {
        setTimeout(() => this.initLeafletMap(), 250);
        return;
      }

      try {
        // High-Resolution Maritime & Satellite Tile Layers (100% Free, Zero Watermarks, No API Key Required)
        this.tileLayers = {
          satellite: L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
            attribution: 'Satellite &copy; Esri, Maxar, Earthstar Geographics',
            maxZoom: 18
          }),
          nautical: L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 19
          }),
          radar: L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}', {
            attribution: '&copy; Esri, HERE, Garmin, OpenStreetMap contributors',
            maxZoom: 16
          })
        };

        this.currentLayer = this.tileLayers.satellite;

        this.leafletMap = L.map('leafletLiveMap', {
          zoomControl: true,
          attributionControl: true,
          scrollWheelZoom: false,
          layers: [this.currentLayer],
          minZoom: 2,
          maxZoom: 16
        });

        // Interactive mousewheel zoom on hover/click
        container.addEventListener('mouseenter', () => {
          if (this.leafletMap) this.leafletMap.scrollWheelZoom.enable();
        });
        container.addEventListener('mouseleave', () => {
          if (this.leafletMap) this.leafletMap.scrollWheelZoom.disable();
        });

        // Initial render for active consignment
        const data = CONSIGNMENT_DB[this.currentId];
        if (data) {
          this.renderMap(data);
        }
      } catch (err) {
        console.warn('Leaflet map initialization notice:', err);
      }
    },

    bindEvents: function () {
      const searchForm = document.getElementById('trackingSearchForm');
      const searchInput = document.getElementById('trackingSearchInput');
      const pasteBtn = document.getElementById('pasteClipboardBtn');
      const copyLinkBtn = document.getElementById('copyTrackingLinkBtn');
      const printBtn = document.getElementById('printWaybillBtn');
      const alertsModalBtn = document.getElementById('openAlertsModalBtn');
      const closeModalBtn = document.getElementById('closeModalBtn');
      const alertsModal = document.getElementById('alertsModal');
      const subscribeForm = document.getElementById('subscribeAlertsForm');
      const clearBtn = document.getElementById('clearSearchBtn');
      const recenterBtn = document.getElementById('btnRecenterVessel');

      if (searchForm) {
        searchForm.addEventListener('submit', (e) => {
          e.preventDefault();
          this.handleSearch();
        });
      }

      if (clearBtn && searchInput) {
        clearBtn.addEventListener('click', () => {
          searchInput.value = '';
          searchInput.focus();
        });
      }

      if (pasteBtn && searchInput) {
        pasteBtn.addEventListener('click', async () => {
          try {
            const text = await navigator.clipboard.readText();
            if (text) {
              searchInput.value = text.trim();
              this.handleSearch();
            }
          } catch (err) {
            this.showToast('Please type or paste your tracking ID manually.');
          }
        });
      }

      if (copyLinkBtn) {
        copyLinkBtn.addEventListener('click', () => {
          const url = `${window.location.origin}${window.location.pathname}?id=${this.currentId}`;
          if (navigator.clipboard) {
            navigator.clipboard.writeText(url).then(() => {
              this.showToast(`Tracking link copied: ${this.currentId}`);
            });
          } else {
            this.showToast(`URL: ${url}`);
          }
        });
      }

      if (printBtn) {
        printBtn.addEventListener('click', () => {
          window.print();
        });
      }

      if (alertsModalBtn && alertsModal) {
        alertsModalBtn.addEventListener('click', () => {
          alertsModal.classList.add('open');
        });
      }

      if (closeModalBtn && alertsModal) {
        closeModalBtn.addEventListener('click', () => {
          alertsModal.classList.remove('open');
        });
      }

      if (alertsModal) {
        alertsModal.addEventListener('click', (e) => {
          if (e.target === alertsModal) {
            alertsModal.classList.remove('open');
          }
        });
      }

      if (subscribeForm && alertsModal) {
        subscribeForm.addEventListener('submit', (e) => {
          e.preventDefault();
          alertsModal.classList.remove('open');
          this.showToast(`Subscribed! Live milestone alerts activated for ${this.currentId}`);
        });
      }

      if (recenterBtn) {
        recenterBtn.addEventListener('click', () => {
          this.centerOnVessel();
        });
      }

      // Map Mode buttons
      document.querySelectorAll('.btn-map-mode').forEach(btn => {
        btn.addEventListener('click', (e) => {
          const mode = btn.getAttribute('data-mode');
          if (mode) this.setMapMode(mode);
        });
      });
    },

    setMapMode: function (mode) {
      this.mapMode = mode;
      document.querySelectorAll('.btn-map-mode').forEach(b => {
        if (b.getAttribute('data-mode') === mode) {
          b.classList.add('active');
        } else {
          b.classList.remove('active');
        }
      });

      const viewport = document.getElementById('mapViewport');
      if (viewport) {
        if (mode === 'radar') {
          viewport.classList.add('radar-active');
        } else {
          viewport.classList.remove('radar-active');
        }
      }

      if (this.leafletMap && this.tileLayers && this.tileLayers[mode]) {
        if (this.currentLayer) {
          this.leafletMap.removeLayer(this.currentLayer);
        }
        this.currentLayer = this.tileLayers[mode];
        this.leafletMap.addLayer(this.currentLayer);
      }

      const modeNames = {
        satellite: 'Satellite AIS Imagery',
        nautical: 'Nautical Voyager Chart',
        radar: 'Night Radar Scanning Mode'
      };
      this.showToast(`Switched map to ${modeNames[mode] || mode.toUpperCase()}`);
    },

    centerOnVessel: function () {
      const data = CONSIGNMENT_DB[this.currentId];
      if (this.leafletMap && data && data.geoVessel) {
        this.leafletMap.flyTo(data.geoVessel, 5, { animate: true, duration: 1.2 });
        if (this.mapMarkers.vessel) {
          setTimeout(() => {
            this.mapMarkers.vessel.openPopup();
          }, 600);
        }
        this.showToast(`Camera centered on ${data.vesselName} (${data.speed})`);
      } else {
        this.showToast('Vessel position centered');
      }
    },

    startLiveSimulation: function () {
      if (this.pingInterval) clearInterval(this.pingInterval);
      let countdown = 12;

      this.pingInterval = setInterval(() => {
        countdown--;
        const syncEl = document.getElementById('renderAisSyncCountdown');
        if (syncEl) {
          if (countdown <= 0) {
            countdown = 15;
            syncEl.innerHTML = `<span class="trk-pulse-dot"></span> AIS Synced Just Now`;
            this.microUpdateTelemetry();
          } else {
            syncEl.innerHTML = `<span class="trk-pulse-dot"></span> Next AIS Sync: ${countdown}s`;
          }
        }
      }, 1000);
    },

    microUpdateTelemetry: function () {
      const data = CONSIGNMENT_DB[this.currentId];
      if (!data) return;

      // Slight speed micro-jitter simulating live ocean telemetry
      const speedEl = document.getElementById('renderSpeed');
      const hudSpeedEl = document.getElementById('hudVesselSpeed');
      if (speedEl && data.speed.includes('Knots')) {
        const baseSpeed = parseFloat(data.speed) || 19.4;
        const jitter = (baseSpeed + (Math.random() * 0.4 - 0.2)).toFixed(1);
        speedEl.textContent = `${jitter} Knots`;
        if (hudSpeedEl) hudSpeedEl.textContent = `${jitter} Knots`;
      }
    },

    pulseVesselMarker: function () {
      if (this.mapMarkers && this.mapMarkers.vessel) {
        const el = this.mapMarkers.vessel.getElement();
        if (el) {
          el.style.transition = 'transform 0.3s ease';
          el.style.transform = `${el.style.transform} scale(1.35)`;
          setTimeout(() => {
            el.style.transform = el.style.transform.replace(' scale(1.35)', '');
          }, 400);
        }
      }
    },

    renderMap: function (data) {
      if (!this.leafletMap || !data || typeof L === 'undefined') return;

      // Remove existing route and markers
      if (this.mapMarkers.routeGlow) {
        this.leafletMap.removeLayer(this.mapMarkers.routeGlow);
        this.mapMarkers.routeGlow = null;
      }
      if (this.mapMarkers.routeLead) {
        this.leafletMap.removeLayer(this.mapMarkers.routeLead);
        this.mapMarkers.routeLead = null;
      }
      if (this.mapMarkers.origin) {
        this.leafletMap.removeLayer(this.mapMarkers.origin);
        this.mapMarkers.origin = null;
      }
      if (this.mapMarkers.dest) {
        this.leafletMap.removeLayer(this.mapMarkers.dest);
        this.mapMarkers.dest = null;
      }
      if (this.mapMarkers.vessel) {
        this.leafletMap.removeLayer(this.mapMarkers.vessel);
        this.mapMarkers.vessel = null;
      }

      const routeCoords = data.geoRoute || [];
      const originCoord = data.geoOrigin || routeCoords[0];
      const destCoord = data.geoDest || routeCoords[routeCoords.length - 1];
      const vesselCoord = data.geoVessel || routeCoords[Math.floor(routeCoords.length / 2)];

      if (!routeCoords.length) return;

      // 1. Multi-Layer Neon Nautical Route
      this.mapMarkers.routeGlow = L.polyline(routeCoords, {
        color: '#0284c7',
        weight: 8,
        opacity: 0.35,
        lineCap: 'round',
        lineJoin: 'round'
      }).addTo(this.leafletMap);

      this.mapMarkers.routeLead = L.polyline(routeCoords, {
        color: '#df8b1a',
        weight: 3.5,
        opacity: 0.95,
        dashArray: '10, 8',
        lineCap: 'round',
        lineJoin: 'round',
        className: 'ais-route-lead'
      }).addTo(this.leafletMap);

      // 2. Custom Origin Port Beacon
      const isAir = (data.containerType && data.containerType.includes('Pharma')) || (data.carrierCode === 'EK');
      const originIconHtml = isAir ? '<i class="fa-solid fa-plane-departure"></i>' : '<i class="fa-solid fa-anchor"></i>';
      const destIconHtml = isAir ? '<i class="fa-solid fa-plane-arrival"></i>' : '<i class="fa-solid fa-flag-checkered"></i>';
      const vesselIconClass = isAir ? 'fa-plane' : 'fa-ship';

      const originIcon = L.divIcon({
        className: 'leaflet-ais-port-pin port-pin-origin',
        html: `
          <div class="port-pin-beacon">${originIconHtml}</div>
          <div class="port-pin-ripple"></div>
        `,
        iconSize: [20, 20],
        iconAnchor: [10, 10]
      });

      this.mapMarkers.origin = L.marker(originCoord, { icon: originIcon })
        .addTo(this.leafletMap)
        .bindPopup(`
          <div class="ais-custom-popup">
            <div class="ais-popup-inner">
              <div class="ais-popup-title">${originIconHtml} <span>${data.originPort}</span></div>
              <div class="ais-popup-row">${data.originCity}, ${data.originCountry}</div>
              <div class="ais-popup-row">Departure: <strong>${data.departureDate}</strong></div>
              <div class="ais-popup-row">Customs: <strong>${data.iceGateStatus.split(' ')[0]} Verified</strong></div>
            </div>
          </div>
        `);

      // 3. Custom Destination Port Beacon
      const destIcon = L.divIcon({
        className: 'leaflet-ais-port-pin port-pin-dest',
        html: `
          <div class="port-pin-beacon">${destIconHtml}</div>
          <div class="port-pin-ripple"></div>
        `,
        iconSize: [20, 20],
        iconAnchor: [10, 10]
      });

      this.mapMarkers.dest = L.marker(destCoord, { icon: destIcon })
        .addTo(this.leafletMap)
        .bindPopup(`
          <div class="ais-custom-popup">
            <div class="ais-popup-inner">
              <div class="ais-popup-title">${destIconHtml} <span>${data.destPort}</span></div>
              <div class="ais-popup-row">${data.destCity}, ${data.destCountry}</div>
              <div class="ais-popup-row">Estimated Arrival: <strong>${data.eta}</strong></div>
              <div class="ais-popup-row">Status: <strong>${data.status}</strong></div>
            </div>
          </div>
        `);

      // 4. Custom Live AIS Vessel Marker with Radar Ring
      const vesselIcon = L.divIcon({
        className: 'leaflet-ais-vessel-marker',
        html: `
          <div class="vessel-beacon-wrap">
            <div class="vessel-ping-halo"></div>
            <div class="vessel-ship-badge"><i class="fa-solid ${vesselIconClass}"></i></div>
            <div class="vessel-callout-tag">${data.vesselName.split(' ')[0]} • ${data.speed}</div>
          </div>
        `,
        iconSize: [32, 32],
        iconAnchor: [16, 16]
      });

      this.mapMarkers.vessel = L.marker(vesselCoord, { icon: vesselIcon, zIndexOffset: 2000 })
        .addTo(this.leafletMap)
        .bindPopup(`
          <div class="ais-custom-popup">
            <div class="ais-popup-inner">
              <div class="ais-popup-title"><i class="fa-solid ${vesselIconClass}" style="color: #df8b1a;"></i> <span>${data.vesselName}</span></div>
              <div class="ais-popup-row">Carrier: <strong>${data.carrier}</strong> (${data.carrierCode})</div>
              <div class="ais-popup-row">Live Telemetry: <strong>${data.speed} • ${data.heading}</strong></div>
              <div class="ais-popup-row">AIS Coordinates: <strong>${data.coordinates}</strong></div>
              <div class="ais-popup-row">Sea State: <strong>${data.seaState}</strong></div>
              <div class="ais-popup-row">Distance Sailed: <strong>${data.distanceSailed}</strong></div>
            </div>
          </div>
        `);

      // 5. Fit bounds smoothly with balanced zoom framing
      const bounds = L.latLngBounds(routeCoords);
      this.leafletMap.fitBounds(bounds, { padding: [30, 30], maxZoom: 4 });

      // Update Floating HUD Badge
      const badgeText = document.getElementById('mapFloatingBadgeText');
      if (badgeText) {
        badgeText.textContent = `${data.vesselName} • AIS Telemetry Active (${data.speed} / ${data.heading})`;
      }
    },

    checkUrlParams: function () {
      const params = new URLSearchParams(window.location.search);
      const queryId = params.get('id') || params.get('bl') || params.get('container') || params.get('q');
      if (queryId) {
        const foundId = this.findShipmentId(queryId);
        if (foundId) {
          this.currentId = foundId;
          const input = document.getElementById('trackingSearchInput');
          if (input) input.value = queryId;
        }
      }
    },

    findShipmentId: function (query) {
      if (!query) return null;
      const clean = query.trim().toUpperCase();

      if (CONSIGNMENT_DB[clean]) return clean;

      // Check numeric suffix or partial code (e.g. "891", "0891")
      for (const key of Object.keys(CONSIGNMENT_DB)) {
        if (key.endsWith(clean) || key.includes(clean)) {
          return key;
        }
      }

      // Check B/L, container, booking, commodity, vessel, port names
      for (const [key, data] of Object.entries(CONSIGNMENT_DB)) {
        if (
          key.toUpperCase() === clean ||
          data.blNumber.toUpperCase().includes(clean) ||
          data.containerNo.toUpperCase().includes(clean) ||
          data.bookingRef.toUpperCase().includes(clean) ||
          data.carrier.toUpperCase().includes(clean) ||
          data.vesselName.toUpperCase().includes(clean) ||
          data.commodity.toUpperCase().includes(clean) ||
          data.originPort.toUpperCase().includes(clean) ||
          data.destPort.toUpperCase().includes(clean) ||
          data.destCity.toUpperCase().includes(clean)
        ) {
          return key;
        }
      }

      // Keyword fallback mappings
      if (clean.includes('RICE') || clean.includes('GRAIN') || clean.includes('BASMATI')) return 'SHP-2025-0891';
      if (clean.includes('SPICE') || clean.includes('CHILLI') || clean.includes('DUBAI')) return 'SHP-2025-0890';
      if (clean.includes('SOLAR') || clean.includes('PANEL') || clean.includes('HAMBURG')) return 'SHP-2025-0889';
      if (clean.includes('COTTON') || clean.includes('YARN') || clean.includes('YORK')) return 'SHP-2025-0888';
      if (clean.includes('PHARMA') || clean.includes('MED') || clean.includes('LONDON')) return 'SHP-2025-0887';
      if (clean.includes('OIL') || clean.includes('SESAME') || clean.includes('SINGAPORE')) return 'SHP-2025-0886';

      return null;
    },

    handleSearch: function () {
      const input = document.getElementById('trackingSearchInput');
      if (!input) return;
      const val = input.value.trim();
      if (!val) {
        this.showToast('Please enter a Consignment ID, B/L Number, or Container No.');
        return;
      }

      const submitBtn = document.getElementById('btnTrackCargoSubmit');
      if (submitBtn) {
        const origContent = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fa-solid fa-satellite-dish fa-spin"></i> <span>Tracking...</span>';
        submitBtn.style.opacity = '0.85';
        setTimeout(() => {
          submitBtn.innerHTML = origContent;
          submitBtn.style.opacity = '1';
        }, 400);
      }

      const matchId = this.findShipmentId(val);
      if (matchId) {
        this.currentId = matchId;
        this.render(matchId);
        this.pulseVesselMarker();
        this.showToast(`Cargo Located: ${matchId} (${CONSIGNMENT_DB[matchId].commodity.split(' ')[0]}...)`);
        const mainContent = document.getElementById('trackingMainContent');
        if (mainContent) {
          mainContent.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      } else {
        this.showToast(`Consignment "${val}" not found in current manifest. Showing live demonstration.`);
        this.render('SHP-2025-0891');
        this.pulseVesselMarker();
      }
    },

    selectChip: function (id) {
      if (CONSIGNMENT_DB[id]) {
        this.currentId = id;
        const input = document.getElementById('trackingSearchInput');
        if (input) input.value = id;
        this.render(id);
        this.pulseVesselMarker();
        this.showToast(`Tracking Cargo: ${id}`);
        const mainContent = document.getElementById('trackingMainContent');
        if (mainContent) {
          mainContent.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }
    },

    copyCoordinates: function (coords) {
      if (navigator.clipboard) {
        navigator.clipboard.writeText(coords).then(() => {
          this.showToast(`AIS Coordinates copied: ${coords}`);
        });
      } else {
        this.showToast(`Coordinates: ${coords}`);
      }
    },

    showToast: function (msg) {
      let toast = document.getElementById('trackingToast');
      if (!toast) {
        toast = document.createElement('div');
        toast.id = 'trackingToast';
        toast.className = 'trk-toast-notification';
        document.body.appendChild(toast);
      }
      toast.innerHTML = `<i class="fa-solid fa-circle-check" style="color: #34d399; font-size: 15px;"></i> <span>${msg}</span>`;
      toast.classList.add('show');
      clearTimeout(this._toastTimeout);
      this._toastTimeout = setTimeout(() => {
        toast.classList.remove('show');
      }, 3500);
    },

    render: function (id) {
      const data = CONSIGNMENT_DB[id] || CONSIGNMENT_DB['SHP-2025-0891'];
      this.currentId = data.id;

      // Update active chip state
      document.querySelectorAll('.tracking-chip').forEach((chip) => {
        if (chip.getAttribute('data-id') === data.id) {
          chip.classList.add('active');
        } else {
          chip.classList.remove('active');
        }
      });

      // 1. Master Header Elements
      const shpIdEl = document.getElementById('renderShpId');
      if (shpIdEl) shpIdEl.textContent = data.id;

      const blEl = document.getElementById('renderBlNumber');
      if (blEl) blEl.innerHTML = `<i class="fa-solid fa-file-invoice"></i> B/L: ${data.blNumber}`;

      const carrierEl = document.getElementById('renderCarrier');
      if (carrierEl) carrierEl.innerHTML = `<i class="fa-solid fa-ship"></i> ${data.carrier}`;

      const incotermPillEl = document.getElementById('renderIncotermPill');
      if (incotermPillEl) incotermPillEl.innerHTML = `<i class="fa-solid fa-handshake"></i> ${data.incoterm.split(' ')[0]}`;

      const statusBadgeEl = document.getElementById('renderStatusBadge');
      if (statusBadgeEl) {
        statusBadgeEl.className = `status-state-pill ${data.statusClass}`;
        statusBadgeEl.innerHTML = `<span class="trk-pulse-dot"></span> <i class="fa-solid ${data.statusIcon}"></i> ${data.status}`;
      }

      const progressValEl = document.getElementById('renderProgressVal');
      if (progressValEl) progressValEl.textContent = `${data.progress}% Complete`;

      const progressBarEl = document.getElementById('renderProgressBar');
      if (progressBarEl) progressBarEl.style.width = `${data.progress}%`;

      // 2. Route Endpoints (Module 4)
      const originPortEl = document.getElementById('renderOriginPort');
      if (originPortEl) originPortEl.innerHTML = `${data.originFlag} ${data.originPort}`;

      const originCountryEl = document.getElementById('renderOriginCountry');
      if (originCountryEl) originCountryEl.textContent = `${data.originCity}, ${data.originCountry}`;

      const departureTimeEl = document.getElementById('renderDepartureTime');
      if (departureTimeEl) departureTimeEl.textContent = data.departureDate;

      const destPortEl = document.getElementById('renderDestPort');
      if (destPortEl) destPortEl.innerHTML = `${data.destFlag} ${data.destPort}`;

      const destCountryEl = document.getElementById('renderDestCountry');
      if (destCountryEl) destCountryEl.textContent = `${data.destCity}, ${data.destCountry}`;

      const etaTimeEl = document.getElementById('renderEtaTime');
      if (etaTimeEl) etaTimeEl.textContent = data.eta;

      // 3. Center Passage Vessel
      const vesselNameEl = document.getElementById('renderVesselName');
      if (vesselNameEl) vesselNameEl.innerHTML = `<i class="fa-solid fa-anchor"></i> ${data.vesselName}`;

      const vesselDetailsEl = document.getElementById('renderVesselDetails');
      if (vesselDetailsEl) vesselDetailsEl.textContent = `${data.vesselImo} • ${data.vesselFlag} • MMSI: ${data.vesselMmsi}`;

      const speedEl = document.getElementById('renderSpeed');
      if (speedEl) speedEl.textContent = data.speed;

      const headingEl = document.getElementById('renderHeading');
      if (headingEl) headingEl.textContent = data.heading;

      // 4. MODULE 5: Interactive Real Maritime Leaflet Map & HUD Ticker
      this.renderMap(data);

      // HUD Ticker Values
      const hudCoordsEl = document.getElementById('hudAisCoords');
      if (hudCoordsEl) hudCoordsEl.textContent = data.coordinates;

      const hudSpeedEl = document.getElementById('hudVesselSpeed');
      if (hudSpeedEl) hudSpeedEl.textContent = `${data.speed} (${data.heading})`;

      const hudDistEl = document.getElementById('hudDistanceRemaining');
      if (hudDistEl) hudDistEl.textContent = `${data.distanceRemaining}`;

      const hudPingEl = document.getElementById('hudSatellitePing');
      if (hudPingEl) hudPingEl.textContent = data.satellitePing;

      // 5. MODULE 6A: Cargo & IoT Cold-Chain
      const commodityEl = document.getElementById('renderCommodity');
      if (commodityEl) commodityEl.textContent = data.commodity;

      const hsCodeEl = document.getElementById('renderHsCode');
      if (hsCodeEl) hsCodeEl.textContent = `HS ${data.hsCode}`;

      const containerNoEl = document.getElementById('renderContainerNo');
      if (containerNoEl) containerNoEl.textContent = data.containerNo;

      const containerTypeEl = document.getElementById('renderContainerType');
      if (containerTypeEl) containerTypeEl.textContent = data.containerType;

      const sealNoEl = document.getElementById('renderSealNo');
      if (sealNoEl) sealNoEl.textContent = data.customsSealNo;

      const grossWeightEl = document.getElementById('renderGrossWeight');
      if (grossWeightEl) grossWeightEl.textContent = `${data.grossWeight} (Tare: ${data.tareWeight})`;

      const temperatureEl = document.getElementById('renderTemperature');
      if (temperatureEl) temperatureEl.textContent = data.temperature;

      const tempBarEl = document.getElementById('renderTempBar');
      if (tempBarEl) tempBarEl.style.width = `${data.tempPercent}%`;

      const humidityEl = document.getElementById('renderHumidity');
      if (humidityEl) humidityEl.textContent = data.humidity;

      const humBarEl = document.getElementById('renderHumBar');
      if (humBarEl) humBarEl.style.width = `${data.humidityPercent}%`;

      const shockSensorEl = document.getElementById('renderShockSensor');
      if (shockSensorEl) shockSensorEl.textContent = data.shockSensor;

      // 6. MODULE 6B: Customs & Regulatory
      const sbNoEl = document.getElementById('renderSbNo');
      if (sbNoEl) sbNoEl.textContent = data.iceGateSbNo;

      const iceGateStatusEl = document.getElementById('renderIceGateStatus');
      if (iceGateStatusEl) iceGateStatusEl.textContent = data.iceGateStatus;

      const incotermEl = document.getElementById('renderIncoterm');
      if (incotermEl) incotermEl.textContent = data.incoterm;

      const insuranceEl = document.getElementById('renderInsurance');
      if (insuranceEl) insuranceEl.textContent = data.insurancePolicy;

      const certsEl = document.getElementById('renderCerts');
      if (certsEl) certsEl.textContent = data.certifications;

      // 7. MODULE 6D: Milestone Timeline
      const timelineContainer = document.getElementById('renderMilestonesList');
      if (timelineContainer && data.milestones) {
        let html = '';
        data.milestones.forEach((m) => {
          let stepClass = '';
          let icon = '<i class="fa-solid fa-clock"></i>';
          let badge = '';

          if (m.completed) {
            stepClass = 'completed';
            icon = '<i class="fa-solid fa-check"></i>';
            badge = '<span class="badge-tag-pill badge-tag-green">Completed</span>';
          } else if (m.active) {
            stepClass = 'active';
            icon = '<i class="fa-solid fa-location-dot"></i>';
            badge = '<span class="badge-tag-pill badge-tag-blue"><i class="fa-solid fa-satellite-dish"></i> Live Now</span>';
          } else {
            stepClass = 'upcoming';
            badge = '<span class="badge-tag-pill" style="background: #f1f5f9; color: #64748b;">Scheduled</span>';
          }

          html += `
            <div class="milestone-step-item ${stepClass}">
              <div class="milestone-marker">${icon}</div>
              <div class="milestone-content">
                <div class="milestone-top-line">
                  <span class="milestone-title-text">${m.title}</span>
                  <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="milestone-time-badge">${m.time}</span>
                    ${badge}
                  </div>
                </div>
                <p class="milestone-desc-text">${m.desc}</p>
                <div style="margin-top: 6px; font-size: 11px; color: #64748b; display: flex; align-items: center; gap: 6px;">
                  <i class="fa-solid fa-location-crosshairs" style="color: #0284c7;"></i>
                  <span>${m.location}</span>
                </div>
              </div>
            </div>
          `;
        });
        timelineContainer.innerHTML = html;
      }
    }
  };

  // Expose to window
  window.ConceptTracking = TrackingApp;

  // Initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => TrackingApp.init());
  } else {
    TrackingApp.init();
  }
})();
