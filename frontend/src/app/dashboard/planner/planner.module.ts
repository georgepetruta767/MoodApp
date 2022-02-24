import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {RouterModule, Routes} from "@angular/router";
import {PlannerComponent} from "./planner.component";
import {CalendarModule} from "ion2-calendar";
import {FormsModule} from "@angular/forms";
import {IonicModule} from "@ionic/angular";
import {EventDetailsComponent} from "./event-details/event-details.component";
import {Ng2FilterPipeModule} from "ng2-filter-pipe";

const routes: Routes = [
  {
    path: 'calendar',
    component: PlannerComponent
  },
  {
    path: '',
    redirectTo: 'calendar'
  }
]

@NgModule({
  declarations: [PlannerComponent, EventDetailsComponent],
  imports: [
    CommonModule,
    RouterModule.forChild(routes),
    CalendarModule,
    FormsModule,
    IonicModule,
    Ng2FilterPipeModule
  ]
})
export class PlannerModule { }
