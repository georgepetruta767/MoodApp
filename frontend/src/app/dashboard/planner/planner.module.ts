import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {RouterModule, Routes} from '@angular/router';
import {PlannerComponent} from './planner.component';
import {CalendarModule} from 'ion5-calendar';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {IonicModule} from '@ionic/angular';
import {EventDetailsComponent} from './event-details/event-details.component';
import {Ng2FilterPipeModule} from 'ng2-filter-pipe';
import {SwiperModule} from 'swiper/angular';
import {EventsListComponent} from './events-list/events-list.component';
import {NativeGeocoder} from '@awesome-cordova-plugins/native-geocoder/ngx';

const routes: Routes = [
  {
    path: 'calendar',
    component: PlannerComponent
  },
  {
    path: '',
    redirectTo: 'calendar'
  }
];

@NgModule({
  declarations: [PlannerComponent, EventDetailsComponent, EventsListComponent],
    imports: [
        CommonModule,
        RouterModule.forChild(routes),
        CalendarModule,
        FormsModule,
        IonicModule,
        Ng2FilterPipeModule,
        ReactiveFormsModule,
        SwiperModule
    ],
  providers: [
    NativeGeocoder
  ]
})
export class PlannerModule { }
