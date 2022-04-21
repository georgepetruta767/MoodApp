import {NgModule} from '@angular/core';
import {RouterModule, Routes} from "@angular/router";
import {IonicModule} from "@ionic/angular";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {PlannerComponent} from "./planner/planner.component";
import {PlannerModule} from "./planner/planner.module";
import {PeopleListComponent} from "./people/people-list/people-list.component";
import {EventEditComponent} from "./event-edit/event-edit.component";
import {CommonModule} from "@angular/common";
import {PeopleEditComponent} from "./people/people-edit/people-edit.component";
import {Ng2FilterPipeModule} from "ng2-filter-pipe";
import {SecurityGuard} from "../security/security.guard";
import {ResultsComponent} from "./results/results.component";
import {NgxEchartsModule} from "ngx-echarts";

const routes: Routes = [
  {
    path: 'calendar',
    canActivate: [SecurityGuard],
    component: PlannerComponent,
    loadChildren: () => import('./planner/planner.module').then(m => m.PlannerModule)
  },
  {
    path: 'people',
    component: PeopleListComponent
  },
  {
    path: 'event',
    component: EventEditComponent,
  },
  {
    path: 'event/:id',
    component: EventEditComponent,
  },
  {
    path: '',
    redirectTo: 'calendar'
  },
  {
    path: 'results',
    component: ResultsComponent
  }
]

@NgModule({
  declarations: [PeopleListComponent, PeopleEditComponent, EventEditComponent, ResultsComponent],
  imports: [
    RouterModule.forChild(routes),
    PlannerModule,
    IonicModule,
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    Ng2FilterPipeModule,
    NgxEchartsModule.forRoot({
      echarts: () => import('echarts')
    })
  ]
})
export class DashboardModule {
}
