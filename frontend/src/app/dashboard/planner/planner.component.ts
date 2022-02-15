import {Component, OnInit} from '@angular/core';
import {CalendarComponentOptions, CalendarDay, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {PeopleAddComponent} from "../people/people-add/people-add.component";
import {ModalController} from "@ionic/angular";
import {EventDetailsComponent} from "./event-details/event-details.component";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})
export class PlannerComponent implements OnInit {
  public async ionViewWillEnter(){
    await this.loadEvents();
  }

  public calendarConfig: CalendarComponentOptions = {
    daysConfig: Array<DayConfig>()
  };

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService,
              private modalController: ModalController) { }

  public async ngOnInit() {
    await this.loadEvents();

    this.setupCalendarConfig();
  }

  public setupCalendarConfig() {
    this.events.forEach(event => {
      this.calendarConfig.daysConfig.push({
        date: event.startingTime,
        marked: true
      })
    });
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
    this.setupCalendarConfig();
  }

  public async openEventModal(day: CalendarDay) {
    const date = new Date(day.time);

    if(this.calendarConfig.daysConfig.find(x => new Date(x.date).toDateString() === date.toDateString() && x.marked)) {
      const modal = await this.modalController.create({
        component: EventDetailsComponent,
        breakpoints: [0.3, 0.5, 0.8, 1],
        initialBreakpoint: 0.9,
        componentProps: {
          event: this.events.find(x => new Date(x.startingTime).toDateString() === date.toDateString())
        }
      });
      return await modal.present();
    }
  }
}
