import {Component, Input, OnInit} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";
import {EventStatus} from "../../common/enums/event-status.enum";
import {PersonModel} from "../../common/models/person.model";

@Component({
  selector: 'app-event-details',
  templateUrl: './event-details.component.html',
  styleUrls: ['./event-details.component.scss'],
})
export class EventDetailsComponent implements OnInit {
  @Input()
  public event!: EventModel;

  constructor(private eventsService: EventsService) { }

  public ngOnInit() { }

  public async modifyEventStatus() {
    switch(this.event.status) {
      case EventStatus.Incoming:
        this.event.status = EventStatus.InProgress;
        break;
      case EventStatus.InProgress:
        this.event.status = EventStatus.Finished;
        break;
    }
    await this.eventsService.updateEvent(this.event);
  }

  public getPersonName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }

  public getStatusLabel(status: EventStatus) {
    switch(status) {
      case EventStatus.Incoming:
        return "Incoming";
      case EventStatus.InProgress:
        return "In Progress";
      case EventStatus.Finished:
        return "Completed";
    }
  }

  public getEventAction() {
    switch(this.event.status) {
      case EventStatus.InProgress:
        return "End event";
      case EventStatus.Incoming:
        return "Start event";
    }
  }

  public isEnabled() {
    return this.event.status !== EventStatus.Finished;
  }
}
