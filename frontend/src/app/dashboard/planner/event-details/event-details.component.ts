import {Component, Input, OnInit} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";
import {EventStatus} from "../../common/enums/event-status";

@Component({
  selector: 'app-event-details',
  templateUrl: './event-details.component.html',
  styleUrls: ['./event-details.component.scss'],
})
export class EventDetailsComponent implements OnInit {
  @Input()
  public event!: EventModel;

  constructor(private eventsService: EventsService) { }

  ngOnInit() { }

  public async startEvent() {
    this.event.status = EventStatus.InProgress;
    await this.eventsService.updateEvent(this.event);
  }
}
