from django.contrib import admin
from django.urls import path, reverse_lazy
from . import views
from bots.views import index
from django.contrib.auth import views as auth_views
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib import messages

# Discover admin scripts
admin.autodiscover()

# Define user access permissions
staff_required = user_passes_test(lambda u: u.is_staff)
superuser_required = user_passes_test(lambda u: u.is_superuser)
run_permission = user_passes_test(lambda u: u.has_perm('bots.change_mutex'))

# Import LogoutView from the correct location
from django.contrib.auth.views import LogoutView

class CustomLogoutView(LogoutView):
    template_name = 'admin/logged_out.html'
    next_page = reverse_lazy('home')  # Redirect to home page after logout

    def dispatch(self, request, *args, **kwargs):
        messages.info(request, "You have been successfully logged out.")
        return super().dispatch(request, *args, **kwargs)
    
urlpatterns = [
    # Authentication views
    path('login/', auth_views.LoginView.as_view(template_name='admin/bots_login.html')),
    path('logout/', CustomLogoutView.as_view(), name='logout'),
    path('password_change/', auth_views.PasswordChangeView.as_view(template_name='admin/password_change_form.html'), name='password_change'),
    path('password_change/done/', auth_views.PasswordChangeDoneView.as_view(template_name='admin/password_change_done.html'), name='password_change_done'),
    
    # Login required views
    path('home/', login_required(views.home), name='home'),
    path('incoming/', login_required(views.incoming), name='incoming'),
    path('detail/', login_required(views.detail), name='detail'),
    path('process/', login_required(views.process), name='process'),
    path('outgoing/', login_required(views.outgoing), name='outgoing'),
    path('document/', login_required(views.document), name='document'),
    path('reports/', login_required(views.reports), name='reports'),
    path('confirm/', login_required(views.confirm), name='confirm'),
    path('filer/', login_required(views.filer), name='filer'),
    path('srcfiler/', login_required(views.srcfiler), name='srcfiler'),
    path('logfiler/', login_required(views.logfiler), name='logfiler'),

    # Admin views
    path('admin/', admin.site.urls),

    # Permission-based views
    path('runengine/', run_permission(views.runengine), name='runengine'),
    path('delete/', superuser_required(views.delete), name='delete'),
    path('plugin/index/', superuser_required(views.plugin_index), name='plugin_index'),
    path('plugin/', superuser_required(views.plugin), name='plugin'),
    path('plugout/index/', superuser_required(views.plugout_index), name='plugout_index'),
    path('plugout/backup/', superuser_required(views.plugout_backup), name='plugout_backup'),
    path('plugout/', superuser_required(views.plugout), name='plugout'),
    path('sendtestmail/', superuser_required(views.sendtestmailmanagers), name='sendtestmail'),

    # Homepage
    path('', index, name='index'),
]

# Custom error handler
handler500 = 'bots.views.server_error'
