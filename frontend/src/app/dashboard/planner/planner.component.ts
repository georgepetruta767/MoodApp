import { Component, OnInit } from '@angular/core';
import {CalendarComponentOptions} from "ion2-calendar";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss'],
})
export class PlannerComponent implements OnInit {
  public calendarOptions!: CalendarComponentOptions;
  date!: string;
  type: 'string';
  public isModalVisible = false;

  onChange($event) {
    console.log('fojiasf');
    this.isModalVisible = true;
  }

  constructor() { }

  ngOnInit() {
    this.setupCalendarOptions();
  }

  private setupCalendarOptions() {
    this.calendarOptions = {
      color: 'danger'
    }
  }
}
