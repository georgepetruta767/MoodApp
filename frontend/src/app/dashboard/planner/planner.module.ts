import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {RouterModule, Routes} from "@angular/router";
import {PlannerComponent} from "./planner.component";
import {CalendarModule} from "ion2-calendar";
import {FormsModule} from "@angular/forms";
import {IonDatetime, IonicModule} from "@ionic/angular";

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
  declarations: [PlannerComponent],
  imports: [
    CommonModule,
    RouterModule.forChild(routes),
    CalendarModule,
    FormsModule,
    IonicModule
  ]
})
export class PlannerModule { }
