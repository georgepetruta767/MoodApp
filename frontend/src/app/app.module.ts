import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {RouteReuseStrategy, RouterModule, Routes} from '@angular/router';
import { IonicModule, IonicRouteStrategy } from '@ionic/angular';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import {SecurityModule} from './security/security.module';
import {HttpClientModule} from "@angular/common/http";
import {SecurityGuard} from "./security/security.guard";
import {DashboardPage} from "./dashboard/dashboard.page";

const routes: Routes = [
  {
    path: '',
    canActivate: [SecurityGuard],
    component: DashboardPage,
    loadChildren: () => import('./dashboard/dashboard.module').then((m) => m.DashboardModule)
  },
  {
    path: 'login',
    loadChildren: () => import('./security/security.module').then((m) => m.SecurityModule)
  },
  {
    path: '**',
    redirectTo: 'login',
    pathMatch: 'full'
  }
];

@NgModule({
  declarations: [AppComponent, DashboardPage],
  entryComponents: [],
  imports: [BrowserModule, IonicModule.forRoot(), AppRoutingModule, RouterModule.forRoot(routes), SecurityModule, HttpClientModule],
  providers: [{ provide: RouteReuseStrategy, useClass: IonicRouteStrategy }],
  bootstrap: [AppComponent],
})
export class AppModule {}
