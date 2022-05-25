import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {EventActionModel, EventModel} from '../../common/models/event.model';
import {EventStatus} from '../../common/enums/event-status.enum';
import {PersonModel} from '../../common/models/person.model';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {EventType} from '../../common/enums/event-type.enum';
import {Router} from '@angular/router';
import {Geolocation} from '@capacitor/geolocation';
import {NativeGeocoder, NativeGeocoderOptions} from '@awesome-cordova-plugins/native-geocoder/ngx';
import {AlertController} from "@ionic/angular";

@Component({
  selector: 'app-event-details',
  templateUrl: './event-details.component.html',
  styleUrls: ['./event-details.component.scss'],
})
export class EventDetailsComponent implements OnInit {
  @Input()
  public event!: EventModel;

  @Output()
  public deleteEventEmitter: EventEmitter<string> = new EventEmitter<string>();

  @Output()
  public updateEventEmitter: EventEmitter<EventActionModel> = new EventEmitter<EventActionModel>();

  public hasEndEventButtonBeenClicked = false;

  public form!: FormGroup;

  public options: NativeGeocoderOptions = {
    useLocale: true,
    maxResults: 5
  };

  constructor(private router: Router,
              private nativeGeocoder: NativeGeocoder,
              private alertController: AlertController) { }

  public ngOnInit() {
    this.setupForm();
  }

  public async deleteEvent() {
    const alert = await this.alertController.create({
      cssClass: 'my-custom-class',
      header: 'Alert',
      message: `Are you sure you want to delete event ${this.event.title}?`,
      buttons: [{
        text: 'Delete',
        handler: async () => {
          await this.deleteEventEmitter.emit(this.event.id);
        }
      },
        {
          text: 'Cancel'
        }]
    });

    await alert.present();
  }

  public async updateEvent() {
    switch(this.event.status) {
      case EventStatus.Incoming:
        this.event.status = EventStatus.InProgress;
        this.event.startingTime = new Date(Date.now());

        await Geolocation.checkPermissions();
        await Geolocation.requestPermissions();

        const position = await Geolocation.getCurrentPosition();

        const location = await this.nativeGeocoder.reverseGeocode(position.coords.latitude, position.coords.longitude);

        this.event.location = {
          latitude: Number(location[0].latitude),
          longitude: Number(location[0].longitude),
          city: location[0].locality,
          country: location[0].countryName
        };

        await this.updateEventEmitter.emit({
          eventModel: this.event,
          actionType: 'Start'
        });

        break;
      case EventStatus.InProgress:
        this.event.status = EventStatus.Finished;
        this.event.endingTime = new Date(Date.now());
        this.event.grade = this.form.controls.grade.value;
        this.event.amountSpent = this.form.controls.amountSpent.value;

        await this.updateEventEmitter.emit({
          eventModel: this.event,
          actionType: 'End'
        });
        break;
    }
  }

  public async navigateToUpdateEvent() {
    await this.router.navigateByUrl(`event/${this.event.id}`);
  }

  public getPersonName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }

  public getStatusLabel(status: EventStatus) {
    switch(status) {
      case EventStatus.Incoming:
        return 'Incoming';
      case EventStatus.InProgress:
        return 'In Progress';
      case EventStatus.Finished:
        return 'Completed';
    }
  }

  public getTypeLabel(type: EventType) {
    switch(type) {
      case EventType.Educational:
        return 'Educational';
      case EventType.Recreational:
        return 'Recreational';
      case EventType.WorkRelated:
        return 'Work Related';
    }
  }

  public getEventAction() {
    switch(this.event.status) {
      case EventStatus.InProgress:
        return 'End event';
      case EventStatus.Incoming:
        return 'Start event';
    }
  }

  public isEnabled() {
    return this.event.status !== EventStatus.Finished && this.event.status !== EventStatus.InProgress;
  }

  public async onSubmit() {
    this.hasEndEventButtonBeenClicked = true;
    if(this.form.valid) {
      await this.updateEvent();
    }
  }

  public formatEventDate(date: Date) {
    const options: Intl.DateTimeFormatOptions = {
      day: 'numeric', month: 'long', year: 'numeric'
    };

    return new Date(date).toLocaleDateString('en-GB', options);
  }

  public formatEventTime(date: Date) {
    return new Date(date).toLocaleTimeString(navigator.language, {hour: '2-digit', minute:'2-digit'});
  }

  public padTo2Digits(num: number) {
    if(num < 10)
      {return num.toString();}
    return num.toString().padStart(2, '0');
  }

  public convertMsToTime(milliseconds: number) {
    const seconds = Math.floor(milliseconds / 1000);
    let minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    minutes = minutes % 60;

    return `${this.padTo2Digits(days)}d:${this.padTo2Digits(hours)}h:${this.padTo2Digits(minutes)}m`;
  }

  public getEventDuration() {
    return this.convertMsToTime(new Date(this.event.endingTime).valueOf() - +new Date(this.event.startingTime).valueOf());
  }

  public isStartEventButtonDisabled() {
    if(this.event.status !== EventStatus.Incoming)
      {return false;}


    if(new Date(Date.now()).getFullYear() === new Date(this.event.startingTime).getFullYear() &&
      new Date(Date.now()).getMonth() === new Date(this.event.startingTime).getMonth() &&
      new Date(Date.now()).getDate() !== new Date(this.event.startingTime).getDate()
    ) {
      return true;
    }
    return false;
  }

  private setupForm() {
    this.form = new FormGroup({
      grade: new FormControl('', [Validators.required, Validators.min(1), Validators.max(10)]),
      amountSpent: new FormControl(null, [Validators.min(0)])
    });
  }
}
