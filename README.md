# sciSSOrs
SSO for apps that trust each other

Pre-alpha.

# Tests
The tests are written in ruby but can exercise sciSSOrs implementations in any language.

# Authors

Code by [Daniel Heath](https://github.com/danielheath/)

Protocol by [Clifford Heath](https://github.com/cjheath/)

# Status

So far only the login protocol is implemented, and only for ruby.

# Upcoming
 * Logout
 * Admin -> log other user off
 * Remember me
 * capcha support
 * rate limiting for login attempts
 * server implementation in go
 * client implementation in php
 * one-time-password cookie scheme (protects against attackers stealing old 'remember me' cookies)
