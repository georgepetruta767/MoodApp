import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {RouterModule, Routes} from "@angular/router";
import {IonicModule} from "@ionic/angular";
import {FormsModule} from "@angular/forms";
import {PlannerComponent} from "./planner/planner.component";
import {PlannerModule} from "./planner/planner.module";
import {PeopleComponent} from "./people/people.component";
import {CreateEventComponent} from "./create-event/create-event.component";

const routes: Routes = [
  {
    path: 'calendar',
    component: PlannerComponent,
    loadChildren: () => import('./planner/planner.module').then(m => m.PlannerModule)
  },
  {
    path: 'people',
    component: PeopleComponent
  },
  {
    path: 'event',
    component: CreateEventComponent
  },
  {
    path: '',
    redirectTo: 'calendar'
  }
]

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    RouterModule.forChild(routes),
    PlannerModule,
    IonicModule,
    FormsModule
  ]
})
export class DashboardModule { }
