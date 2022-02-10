import {Component, OnInit} from '@angular/core';
import {CalendarComponentOptions, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";

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

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService) { }

  public async ngOnInit() {
    await this.loadEvents();

    this.setupCalendarConfig();
  }

  public setupCalendarConfig() {
    this.events.forEach(event => {
      this.calendarConfig.daysConfig.push({
        date: event.date,
        marked: true
      })
    })
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
    console.log(this.events);
  }
}
