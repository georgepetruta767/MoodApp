import {Component, Input, OnChanges} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";
import SwiperCore, {EffectCoverflow, Pagination} from "swiper";

SwiperCore.use([EffectCoverflow, Pagination]);

@Component({
  selector: 'app-events-list',
  templateUrl: './events-list.component.html',
  styleUrls: ['./events-list.component.scss'],
})
export class EventsListComponent implements OnChanges {
  public async ngOnChanges() {
    await this.loadEvents();
  }

  @Input()
  public eventsDate: Date;

  public events: Array<EventModel>;

  constructor(private eventService: EventsService) { }

  public async deleteEvent(eventId: string) {
    await this.eventService.deleteEvent(eventId);
    await this.loadEvents();
  }

  public async loadEvents() {
    this.events = await this.eventService.getEvents();
    this.events = this.events.filter(x => new Date(this.eventsDate).getFullYear() === new Date(x.startingTime).getFullYear() &&
      new Date(this.eventsDate).getMonth() === new Date(x.startingTime).getMonth() &&
      new Date(this.eventsDate).getDate() === new Date(x.startingTime).getDate());
  }
}
