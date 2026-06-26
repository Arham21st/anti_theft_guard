/// The role of the currently logged-in web user.
///
/// Drives which destinations, pages, and data scopes are visible in the
/// role-aware web portal. [admin] sees the whole fleet console; [user] sees
/// only their own single device ("my phone" view).
enum UserRole { admin, user }
