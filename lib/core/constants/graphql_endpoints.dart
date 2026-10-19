/// GraphQL endpoint. Used for dashboard KPIs and charts, the trip list and
/// trip detail. Query documents live in each feature's data source.
abstract final class GraphQLEndpoints {
  static const path = '/graphql';
}

/// Keys of a GraphQL-over-HTTP request and response body.
abstract final class GraphQLKeys {
  static const query = 'query';
  static const variables = 'variables';
  static const operationName = 'operationName';
  static const data = 'data';
  static const errors = 'errors';
}
