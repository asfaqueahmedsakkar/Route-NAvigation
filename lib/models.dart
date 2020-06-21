import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigatorModel {
  List<Routes> routes;
  List<Waypoints> waypoints;
  String code;
  String uuid;

  NavigatorModel({this.routes, this.waypoints, this.code, this.uuid});

  NavigatorModel.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = new List<Routes>();
      json['routes'].forEach((v) {
        routes.add(new Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = new List<Waypoints>();
      json['waypoints'].forEach((v) {
        waypoints.add(new Waypoints.fromJson(v));
      });
    }
    code = json['code'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.routes != null) {
      data['routes'] = this.routes.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['uuid'] = this.uuid;
    return data;
  }
}

class Routes {
  String weightName;
  List<Legs> legs;
  Geometry geometry;
  double distance;
  double duration;
  double weight;

  Routes(
      {this.weightName,
      this.legs,
      this.geometry,
      this.distance,
      this.duration,
      this.weight});

  Routes.fromJson(Map<String, dynamic> json) {
    weightName = json['weight_name'];
    if (json['legs'] != null) {
      legs = new List<Legs>();
      json['legs'].forEach((v) {
        legs.add(new Legs.fromJson(v));
      });
    }
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    distance = double.parse(json['distance']?.toString() ?? '0');
    duration = double.parse(json['duration']?.toString() ?? '0');
    weight = double.parse(json['weight']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_name'] = this.weightName;
    if (this.legs != null) {
      data['legs'] = this.legs.map((v) => v.toJson()).toList();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    data['weight'] = this.weight;
    return data;
  }
}

class Legs {
  String summary;
  List<Steps> steps;
  double distance;
  double duration;
  double weight;

  Legs({this.summary, this.steps, this.distance, this.duration, this.weight});

  Legs.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    if (json['steps'] != null) {
      steps = new List<Steps>();
      json['steps'].forEach((v) {
        steps.add(new Steps.fromJson(v));
      });
    }
    distance = double.parse(json['distance']?.toString() ?? '0');
    duration = double.parse(json['duration']?.toString() ?? '0');
    weight = double.parse(json['weight']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    if (this.steps != null) {
      data['steps'] = this.steps.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    data['weight'] = this.weight;
    return data;
  }
}

class Steps {
  List<Intersections> intersections;
  String name;

  double distance;
  Maneuver maneuver;

  double weight;
  Geometry geometry;

  double duration;
  String mode;
  String drivingSide;

  Steps(
      {this.intersections,
      this.name,
      this.distance,
      this.maneuver,
      this.weight,
      this.geometry,
      this.duration,
      this.mode,
      this.drivingSide});

  Steps.fromJson(Map<String, dynamic> json) {
    if (json['intersections'] != null) {
      intersections = new List<Intersections>();
      json['intersections'].forEach((v) {
        intersections.add(new Intersections.fromJson(v));
      });
    }
    name = json['name'];
    distance = double.parse(json['distance']?.toString() ?? '0');
    maneuver = json['maneuver'] != null
        ? new Maneuver.fromJson(json['maneuver'])
        : null;
    weight = double.parse(json['weight']?.toString() ?? '0');
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    duration = double.parse(json['duration']?.toString() ?? '0');
    mode = json['mode'];
    drivingSide = json['driving_side'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.intersections != null) {
      data['intersections'] =
          this.intersections.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['distance'] = this.distance;
    if (this.maneuver != null) {
      data['maneuver'] = this.maneuver.toJson();
    }
    data['weight'] = this.weight;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['duration'] = this.duration;
    data['mode'] = this.mode;
    data['driving_side'] = this.drivingSide;
    return data;
  }
}

class Intersections {
  List<int> bearings;
  List<double> location;
  List<bool> entry;
  int geometryIndex;
  int out;
  int inn;

  double duration;

  Intersections(
      {this.bearings,
      this.location,
      this.entry,
      this.geometryIndex,
      this.out,
      this.inn,
      this.duration});

  Intersections.fromJson(Map<String, dynamic> json) {
    bearings = json['bearings'].cast<int>();
    location = json['location'].cast<double>();
    entry = json['entry'].cast<bool>();
    geometryIndex = json['geometry_index'];
    out = json['out'];
    inn = json['in'];
    duration = double.parse(json['duration']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bearings'] = this.bearings;
    data['location'] = this.location;
    data['entry'] = this.entry;
    data['geometry_index'] = this.geometryIndex;
    data['out'] = this.out;
    data['in'] = this.inn;
    data['duration'] = this.duration;
    return data;
  }
}

class Maneuver {
  String type;
  List<double> location;
  int bearingBefore;
  int bearingAfter;
  String instruction;
  String modifier;
  int exit;

  Maneuver(
      {this.type,
      this.location,
      this.bearingBefore,
      this.bearingAfter,
      this.instruction,
      this.modifier,
      this.exit});

  Maneuver.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    location = json['location'].cast<double>();
    bearingBefore = json['bearing_before'];
    bearingAfter = json['bearing_after'];
    instruction = json['instruction'];
    modifier = json['modifier'];
    exit = json['exit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['location'] = this.location;
    data['bearing_before'] = this.bearingBefore;
    data['bearing_after'] = this.bearingAfter;
    data['instruction'] = this.instruction;
    data['modifier'] = this.modifier;
    data['exit'] = this.exit;
    return data;
  }
}

class Geometry {
  List<LatLng> coordinates;
  String type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = new List<LatLng>();
      json['coordinates'].forEach((v) {
        if (v != null && v.length > 1) coordinates.add(new LatLng(v[1], v[0]));
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }
}

class Waypoints {
  double distance;
  String name;
  List<double> location;

  Waypoints({this.distance, this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    distance = double.parse(json['distance']?.toString() ?? '0');
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
