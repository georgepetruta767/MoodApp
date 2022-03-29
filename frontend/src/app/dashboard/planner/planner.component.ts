import {Component, OnInit, ViewEncapsulation} from '@angular/core';
import {CalendarComponentOptions, CalendarDay, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {PopoverController} from "@ionic/angular";
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
    showMonthPicker: true,
    from: new Date(1),
    daysConfig: Array<DayConfig>()
  };

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService,
              public popoverController: PopoverController) { }

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

  public async openEventPopover(day: CalendarDay) {
    const date = new Date(day.time);

    if(this.calendarConfig.daysConfig.find(x => new Date(x.date).toDateString() === date.toDateString() && x.marked)) {
      const popover = await this.popoverController.create({
        component: EventDetailsComponent,
        componentProps: {
          event: this.events.find(x => new Date(x.startingTime).toDateString() === date.toDateString())
        }
      });

      return await popover.present();
    }
  }
}
