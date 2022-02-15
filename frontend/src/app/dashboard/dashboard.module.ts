import {NgModule} from '@angular/core';
import {RouterModule, Routes} from "@angular/router";
import {IonicModule} from "@ionic/angular";
import {ReactiveFormsModule} from "@angular/forms";
import {PlannerComponent} from "./planner/planner.component";
import {PlannerModule} from "./planner/planner.module";
import {PeopleListComponent} from "./people/people-list/people-list.component";
import {CreateEventComponent} from "./create-event/create-event.component";
import {CommonModule} from "@angular/common";
import {PeopleAddComponent} from "./people/people-add/people-add.component";

const routes: Routes = [
  {
    path: 'calendar',
    component: PlannerComponent,
    loadChildren: () => import('./planner/planner.module').then(m => m.PlannerModule)
  },
  {
    path: 'people',
    component: PeopleListComponent
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
  declarations: [PeopleListComponent, PeopleAddComponent, CreateEventComponent],
  imports: [
    RouterModule.forChild(routes),
    PlannerModule,
    IonicModule,
    CommonModule,
    ReactiveFormsModule
  ]
})
export class DashboardModule {
}
