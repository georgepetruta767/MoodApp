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
        this.event.endingTime = new Date(Date.now());
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

  public padTo2Digits(num: number) {
    if(num < 10)
      return num.toString();
    return num.toString().padStart(2, '0');
  }

  public convertMsToTime(milliseconds: number) {
    let seconds = Math.floor(milliseconds / 1000);
    let minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    seconds = seconds % 60;
    minutes = minutes % 60;

    // 👇️ If you want to roll hours over, e.g. 00 to 24
    // 👇️ uncomment the line below
    // uncommenting next line gets you `00:00:00` instead of `24:00:00`
    // or `12:15:31` instead of `36:15:31`, etc.
    // 👇️ (roll hours over)
    // hours = hours % 24;

    return `${this.padTo2Digits(days)}d:${this.padTo2Digits(hours)}h:${this.padTo2Digits(minutes)}m`;
  }

  public getEventDuration() {
    return this.convertMsToTime(new Date(this.event.endingTime).valueOf() - +new Date(this.event.startingTime).valueOf());
  }

  public isStartEventButtonEnabled() {
    /*if(this.event.status !== EventStatus.Incoming)
      return false;

    if(this.convertMsToTime(new Date(this.event.startingTime).valueOf() - +new Date(Date.now())))
      return true;

    return false;*/

    if(this.event.status !== EventStatus.Incoming)
      return true;


    if(new Date(Date.now()).getFullYear() === new Date(this.event.startingTime).getFullYear() &&
      new Date(Date.now()).getMonth() === new Date(this.event.startingTime).getMonth() &&
      new Date(Date.now()).getDate() < new Date(this.event.startingTime).getDate()
    ) {
      return false;
    }

    return true;
  }
}
