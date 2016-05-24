# See https://github.com/voltrb/volt#routes for more info on routes

client '/about', action: 'about'
client '/registration', action: 'register'
client '/all', action: 'all'
client '/events', action: 'events'
client '/statistics', action: 'statistics'
client '/enrollment', action: 'enrollment'
client '/payment', action: 'payment'
client '/student/edit/{{ id }}', controller: 'student', action: 'edit'
# Routes for login and signup, provided by user_templates component gem

client '/signup', component: 'user_templates', controller: 'signup'
client '/login', component: 'user_templates', controller: 'login', action: 'index'
client '/password_reset', component: 'user_templates', controller: 'password_reset', action: 'index'
client '/forgot', component: 'user_templates', controller: 'login', action: 'forgot'
client '/account', component: 'user_templates', controller: 'account', action: 'index'

# The main route, this should be last. It will match any params not
# previously matched.
client '/', {}
