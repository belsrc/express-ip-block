'use strict';

/**
 * Loops through the given checks and returns the first truthy value.
 * @private
 * @param  {Array}  checks  The list of ip checks.
 * @return {String}
 */
function getFirstIp(checks) {
  for(const i in checks) {
    if(checks[i]) {
      return checks[i];
    }
  }

  return null;
}

/**
 * Tries to get the remote client IP address.
 * @private
 * @param  {Object}   request         The request object.
 * @param  {Boolean}  allowForwarded  Whether or not to allow forwarded-for headers.
 */
function getIp(request, allowForwarded) {
  let checks = [
    request.connection ? request.connection.remoteAddress : null,
    request.socket ? request.socket.remoteAddress : null,
    request.connection && request.connection.socket ? request.connection.socket.remoteAddress : null,
    request.info ? request.info.remoteAddress : null,
  ];

  if(allowForwarded) {
    const forwardChecks = [
      request.headers['x-client-ip'],
      request.headers['x-forwarded-for'],

      // nginx
      request.headers['x-real-ip'],

      // Cloudflare
      request.headers['cf-connecting-ip'],

      // Rackspace, Riverbed
      request.headers['x-cluster-client-ip'],

      // fastly
      request.headers['fastly-ssl'],

      // Zscaler
      request.headers['z-forwarded-for'],

      // alt x-forwarded-for
      request.headers['x-forwarded'],
      request.headers['forwarded-for'],
      request.headers.forwarded,
    ];

    // Need regular checks after forward checks
    checks = forwardChecks.concat(checks);
  }

  let remoteIPs = getFirstIp(checks);

  if(!remoteIPs) {
    return null;
  }

  remoteIPs = remoteIPs.split(',');

  return remoteIPs[0].trim();
}

/**
 * Checks the request IP against a given list of IPs.
 * @module
 * @param   {Array}    ips                       The list of IP addresses.
 * @param   {Object}   [options]                 The options object.
 * @param   {Boolean}  [options.allow]           If true, treats passed IP(s) as whitelisted. Otherwise, treats them as blacklisted. Default is true.
 * @param   {Boolean}  [options.allowForwarded]  If true, checks various forwarded-for headers for an IP. Default is false.
 * @returns {Function} Connect/Express middleware function. <pre><code>function(request, response, next)</code></pre>
 */
module.exports = function(ips, options) {
  options = options || {};

  options.allow = options.allow != null ? options.allow : true;
  options.allowForwarded = options.allowForwarded != null ? options.allowForwarded : false;

  return function(request, response, next) {
    // If there are no IPs then there's no point going further
    if(!ips || !ips.length) {
      return next();
    }

    if(typeof ips === 'string') {
      ips = [ips];
    }

    const ip = getIp(request, options.allowForwarded);

    // Given IPs are blacklist. If the request IP matches any in the list they will get a 403 response.
    // Otherwise, it will move to the next middleware
    if(!options.allow) {
      return ips.indexOf(ip) === -1 ? next() : response.sendStatus(403);
    }

    // Given IPs are whitelist. If the request IP matches any in the list, it will move to the next middleware
    // Otherwise, they will get a 403 response
    return ips.indexOf(ip) !== -1 ? next() : response.sendStatus(403);
  };
};
