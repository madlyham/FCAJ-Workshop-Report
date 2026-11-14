function handler(event) {
  var req = event.request;
  // Only real asset extensions pass; chat route "<partnerId>.<listingId>" also contains a dot
  if (!/\.(js|mjs|css|map|html|png|jpe?g|gif|svg|ico|webp|avif|txt|json|xml|webmanifest|woff2?|ttf)$/i.test(req.uri)) req.uri = '/index.html';
  return req;
}