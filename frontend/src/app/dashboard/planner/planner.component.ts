import {Component, OnInit} from '@angular/core';
import {CalendarComponentOptions, CalendarDay, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss'],
})
export class PlannerComponent implements OnInit {
  public async ionViewWillEnter(){
    await this.loadEvents();
  }

  public calendarConfig: CalendarComponentOptions = {
    daysConfig: Array<DayConfig>()
  };

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
    });
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
    this.setupCalendarConfig();
  }

  public openEventModal(day: CalendarDay) {

  }
}
