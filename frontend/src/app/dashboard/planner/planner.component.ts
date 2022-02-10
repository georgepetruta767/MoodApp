import {Component, OnInit} from '@angular/core';
import {CalendarComponent, CalendarComponentOptions, CalendarOptions, DayConfig} from "ion2-calendar";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss'],
})
export class PlannerComponent implements OnInit {
  public calendarConfig: CalendarComponentOptions = {
    daysConfig: Array<DayConfig>()
  };

  dateMulti: string[];
  type: 'string'; // 'string' | 'js-date' | 'moment' | 'time' | 'object'
  /*optionsMulti: CalendarComponentOptions = {
  };*/

  constructor() { }

  ngOnInit() {
/*
    this.calendarConfig.daysConfig = new Array<DayConfig>();
*/
    this.calendarConfig.daysConfig.push({
      date: new Date(2022, 1, 11),
      marked: true
    })

    console.log(this.calendarConfig.daysConfig);
  }
}
