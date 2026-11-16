import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches products from remote REST API, falling back to Sankar Group enterprise repository
  Future<List<ProductModel>> fetchProducts({String? category, String? query}) async {
    try {
      // 1. First, attempt to fetch from the public REST API
      String url = '${ApiEndpoints.publicBaseUrl}${ApiEndpoints.productsPath}?limit=20';
      if (query != null && query.trim().isNotEmpty) {
        url = '${ApiEndpoints.publicBaseUrl}${ApiEndpoints.searchPath}?q=${Uri.encodeComponent(query.trim())}';
      }

      final response = await _client.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(ApiEndpoints.requestTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        
        // Convert API items to ProductModel
        List<ProductModel> apiProducts = productsJson
            .map((item) => ProductModel.fromDummyJson(item))
            .toList();

        // Blend with specialized Sankar Group industrial components
        List<ProductModel> allProducts = [..._getSankarCatalog(), ...apiProducts];

        // Apply local filtering if specified
        return _applyFilters(allProducts, category: category, query: query);
      } else {
        // HTTP error response fallback
        return _applyFilters(_getSankarCatalog(), category: category, query: query);
      }
    } on SocketException {
      // Offline / No Internet - return structured local data
      return _applyFilters(_getSankarCatalog(), category: category, query: query);
    } catch (e) {
      // Any other exception / timeout - graceful fallback to local data
      return _applyFilters(_getSankarCatalog(), category: category, query: query);
    }
  }

  /// Fetches available product categories
  Future<List<CategoryModel>> fetchCategories() async {
    // Sankar Group Core Business Product Categories
    return const [
      CategoryModel(
        id: 'all',
        name: 'All Components',
        description: 'Complete Sankar Sealing Systems Portfolio',
        icon: Icons.grid_view_rounded,
        itemCount: 16,
      ),
      CategoryModel(
        id: 'cylinder_gaskets',
        name: 'MLS Cylinder Gaskets',
        description: 'Multi-layer steel cylinder head gaskets for high compression engines',
        icon: Icons.layers_rounded,
        itemCount: 4,
      ),
      CategoryModel(
        id: 'thermal_shields',
        name: 'Thermal Heat Shields',
        description: 'Embossed aluminum & high-temp exhaust heat management shields',
        icon: Icons.local_fire_department_rounded,
        itemCount: 3,
      ),
      CategoryModel(
        id: 'nvh_shims',
        name: 'NVH & Brake Shims',
        description: 'Multi-layer anti-squeal shims and vibration dampers',
        icon: Icons.graphic_eq_rounded,
        itemCount: 3,
      ),
      CategoryModel(
        id: 'elastomers',
        name: 'Specialty Elastomers',
        description: 'FKM, NBR, and EPDM molded rubber seals and O-rings',
        icon: Icons.donut_large_rounded,
        itemCount: 4,
      ),
      CategoryModel(
        id: 'exhaust_seals',
        name: 'Exhaust & Turbo Seals',
        description: 'High-temperature spiral wound and graphite gaskets',
        icon: Icons.alt_route_rounded,
        itemCount: 2,
      ),
    ];
  }

  /// Filter products by category or search term
  List<ProductModel> _applyFilters(
    List<ProductModel> list, {
    String? category,
    String? query,
  }) {
    var filtered = list;

    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      filtered = filtered.where((p) {
        return p.category.toLowerCase().contains(category.toLowerCase()) ||
            p.category.toLowerCase().replaceAll(' ', '_') == category.toLowerCase();
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    return filtered;
  }

  /// Authentic Sankar Group flagship automotive & industrial components catalog
  List<ProductModel> _getSankarCatalog() {
    return const [
      ProductModel(
        id: 'sg-001',
        title: 'MLS Cylinder Head Gasket (Multi-Layer Steel)',
        sku: 'SG-CHG-9840',
        category: 'MLS Cylinder Gaskets',
        description:
            'Precision engineered 3-layer steel gasket with full elastomer coating. Designed for modern high-boost turbocharged passenger and commercial vehicle engines.',
        price: 1850.00,
        minOrderQuantity: 50,
        rating: 4.9,
        reviewCount: 48,
        stockStatus: 'In Stock (Chennai Warehouse)',
        imageUrl:
            'https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=600&q=80',
          'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Material': 'High-Tensile Spring Steel + NBR Viton Coating',
          'Operating Temp': '-40°C to +350°C',
          'Nominal Thickness': '1.20 mm',
          'Bore Size': '86.5 mm',
          'Certification': 'IATF 16949 / ISO 9001',
        },
        applications: ['Hyundai', 'Tata Motors', 'Mahindra', 'Ashok Leyland'],
        isFeatured: true,
        materialGrade: 'Grade 301 Stainless Full Hard',
      ),
      ProductModel(
        id: 'sg-002',
        title: 'Turbocharger & Exhaust Manifold Thermal Shield',
        sku: 'SG-THS-4421',
        category: 'Thermal Heat Shields',
        description:
            'Embossed dual-layer micro-perforated aluminum heat shield with ceramic insulation core. Provides up to 65% radiative heat attenuation around exhaust manifolds.',
        price: 1420.00,
        minOrderQuantity: 25,
        rating: 4.8,
        reviewCount: 32,
        stockStatus: 'In Stock',
        imageUrl:
            'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Material': 'Embossed 5052-H32 Aluminum + Biosoluble Fiber',
          'Continuous Temp': 'Up to 900°C',
          'Thickness': '0.40 mm Dual Sheet',
          'Acoustic Damping': '-6 dB insertion loss',
          'Certification': 'OEM Approved Tier-1',
        },
        applications: ['Commercial Trucks', 'SUV Turbochargers', 'Industrial Gensets'],
        isFeatured: true,
        materialGrade: 'Aero-grade Embossed Alloy',
      ),
      ProductModel(
        id: 'sg-003',
        title: 'Multi-Layer NVH Brake Caliper Anti-Squeal Shim',
        sku: 'SG-NVH-1108',
        category: 'NVH & Brake Shims',
        description:
            'Specially bonded rubber-steel-rubber constrained layer damper. Effectively decouples vibrational modes between the brake caliper piston and backplate, eliminating high-frequency squeal.',
        price: 360.00,
        minOrderQuantity: 200,
        rating: 4.7,
        reviewCount: 56,
        stockStatus: 'In Stock',
        imageUrl:
            'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Structure': 'Cold Rolled Steel Core + Dual Viscoelastic Elastomer',
          'Damping Loss Factor': 'η > 0.18 at 20°C - 100°C',
          'Adhesive': 'Modified Acrylic Pressure Sensitive',
          'Thickness': '0.75 mm',
        },
        applications: ['Brake Calipers', 'Rail Brake Systems', 'Two-Wheelers'],
        isFeatured: true,
        materialGrade: 'SAE J661 Tested Compliant',
      ),
      ProductModel(
        id: 'sg-004',
        title: 'FKM Viton High-Performance Radial Oil Seal',
        sku: 'SG-ELA-7022',
        category: 'Specialty Elastomers',
        description:
            'Fluorocarbon (FKM) elastomer rotary shaft seal with stainless steel garter spring. Superior resistance to synthetic engine oils, high temperatures, and aggressive additives.',
        price: 490.00,
        minOrderQuantity: 100,
        rating: 4.9,
        reviewCount: 41,
        stockStatus: 'In Stock',
        imageUrl:
            'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Elastomer Type': 'Fluoroelastomer (FKM 75 ShA)',
          'Spring': 'SUS 304 Stainless Steel',
          'Shaft Speed': 'Up to 35 m/s',
          'Operating Pressure': 'Max 0.05 MPa',
        },
        applications: ['Crankshaft Front/Rear', 'Transmission Input', 'Differential'],
        isFeatured: false,
        materialGrade: 'ASTM D2000 Grade HK',
      ),
      ProductModel(
        id: 'sg-005',
        title: 'Spiral Wound Exhaust Flange Gasket with Graphite',
        sku: 'SG-EXH-3390',
        category: 'Exhaust & Turbo Seals',
        description:
            'V-shaped metallic strip and soft flexible graphite filler winding. Engineered for thermal cycling resistance in heavy vehicle turbocharger downpipes.',
        price: 880.00,
        minOrderQuantity: 40,
        rating: 4.6,
        reviewCount: 19,
        stockStatus: 'In Stock',
        imageUrl:
            'https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Winding Strip': 'SS 316L',
          'Filler': 'Flexible Nuclear Grade Graphite (99.5%)',
          'Rating': 'Class 150 / 300 DIN',
          'Max Pressure': '40 Bar',
        },
        applications: ['Diesel Gensets', 'Heavy Mining Trucks', 'Locomotives'],
        isFeatured: false,
        materialGrade: 'ASME B16.20 Standard',
      ),
      ProductModel(
        id: 'sg-006',
        title: 'Precision Precision Shims & Spacers Set',
        sku: 'SG-SHM-5510',
        category: 'NVH & Brake Shims',
        description:
            'Ultra-precision stamped stainless steel shims for tolerance compensation and clearance adjustment in transmissions and driveline assemblies.',
        price: 210.00,
        minOrderQuantity: 250,
        rating: 4.8,
        reviewCount: 38,
        stockStatus: 'In Stock',
        imageUrl:
            'https://images.unsplash.com/photo-1581092335397-9583fe92d232?auto=format&fit=crop&w=600&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1581092335397-9583fe92d232?auto=format&fit=crop&w=600&q=80',
        ],
        specifications: {
          'Thickness Range': '0.05 mm to 2.00 mm (0.01 mm increments)',
          'Flatness': 'Within 0.02 mm',
          'Material': 'DIN 1.4310 Hardened Spring Steel',
        },
        applications: ['Gearbox Bearings', 'Suspension Alignment', 'Robotics'],
        isFeatured: false,
        materialGrade: 'Precision Class A',
      ),
    ];
  }
}
