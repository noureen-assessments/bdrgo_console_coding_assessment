abstract final class LiveMapQueries {
  static const driverDetail = r'''
    query DriverDetail($id: ID!) {
      driver(id: $id) {
        id
        name
        phone
        rating
        status
        vehicle {
          make
          model
          color
          plate
        }
        currentTrip {
          id
          pickup {
            address
          }
          dropoff {
            address
          }
          fare {
            amount
            currency
          }
        }
      }
    }
  ''';

  static Map<String, Object?> driverDetailVariables(String id) => {'id': id};
}
