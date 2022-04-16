import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";
import {EventStatus} from "../../common/enums/event-status.enum";
import {PersonModel} from "../../common/models/person.model";
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {EventType} from "../../common/enums/event-type.enum";

@Component({
  selector: 'app-event-details',
  templateUrl: './event-details.component.html',
  styleUrls: ['./event-details.component.scss'],
})
export class EventDetailsComponent implements OnInit {
  @Input()
  public event!: EventModel;

  @Output()
  public closePopoverEmitter!: EventEmitter<any>;

  public form!: FormGroup;

  constructor(private eventsService: EventsService) { }

  public ngOnInit() {
    this.setupForm();

    if(!navigator.geolocation){
      console.log('location is not supported');
    }

    navigator.geolocation.getCurrentPosition(position => {
      /*let loc = this.getReverseGeocodingData(position.coords.latitude, position.coords.longitude);*/
      console.log(position);
    });
  }

  public setupForm() {
    this.form = new FormGroup({
      grade: new FormControl('', [Validators.required, Validators.min(1), Validators.max(10)])
    });
  }

  public async updateEvent() {
    switch(this.event.status) {
      case EventStatus.Incoming:
        this.event.status = EventStatus.InProgress;
        break;
      case EventStatus.InProgress:
        this.event.status = EventStatus.Finished;
        this.event.endingTime = new Date();
        this.event.grade = this.form.controls.grade.value;
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

  public getTypeLabel(type: EventType) {
    switch(type) {
      case EventType.Educational:
        return "Educational";
      case EventType.Recreational:
        return "Recreational";
      case EventType.WorkRelated:
        return "Work Related";
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
    return this.event.status !== EventStatus.Finished && this.event.status !== EventStatus.InProgress;
  }

  public async onSubmit() {
    if(this.form.valid) {
      await this.updateEvent();
      this.closePopoverEmitter.emit();
    }
  }

  public formatEventDate(date: Date) {
    let options: Intl.DateTimeFormatOptions = {
      day: "numeric", month: "long", year: "numeric"
    };

    return new Date(date).toLocaleDateString("en-GB", options);
  }

  public formatEventTime(date: Date) {
    return new Date(date).toLocaleTimeString(navigator.language, {hour: '2-digit', minute:'2-digit'});
  }
}
