import {Component, Input, OnInit} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";

@Component({
  selector: 'app-events-list',
  templateUrl: './events-list.component.html',
  styleUrls: ['./events-list.component.scss'],
})
export class EventsListComponent implements OnInit {
  public async ionViewWillEnter() {
  }

  public async ngOnInit() {
    this.events = new Array<EventModel>();
    this.events = await this.eventService.getEvents();
    this.events = this.events.filter(x => this.eventsDate.getFullYear() === new Date(x.startingTime).getFullYear() &&
      this.eventsDate.getMonth() === new Date(x.startingTime).getMonth() &&
      this.eventsDate.getDate() === new Date(x.startingTime).getDate() )
  }

  @Input()
  public eventsDate: Date;

  public events: Array<EventModel>;

  constructor(private eventService: EventsService) { }
}
