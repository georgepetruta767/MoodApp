import {Component, OnInit} from '@angular/core';
import {CalendarComponent, CalendarComponentOptions, CalendarOptions, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";

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
  type: 'string';

  public events!: EventModel;

  constructor() { }

  ngOnInit() {
    this.calendarConfig.daysConfig.push({
      date: new Date(2022, 1, 11),
      marked: true
    })
    this.loadEvents();
  }

  public loadEvents() {
    this.events = this/
  }
}
