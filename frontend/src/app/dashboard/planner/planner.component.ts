import {AfterViewInit, ChangeDetectorRef, Component, OnInit, ViewChild} from '@angular/core';
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {NativeGeocoder, NativeGeocoderOptions, NativeGeocoderResult} from "@ionic-native/native-geocoder/ngx";
import {FormControl, FormGroup} from "@angular/forms";
import {IonContent, IonDatetime} from "@ionic/angular";
import { getDate, getMonth, getYear } from 'date-fns';
import {CalendarComponentOptions, DayConfig} from "ion2-calendar";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})

export class PlannerComponent implements OnInit {
  @ViewChild(IonContent, { static: true })
  public content: IonContent;

  public calendarConfig!: CalendarComponentOptions;

  public async ionViewWillEnter(){
    await this.loadEvents();

    this.setupCalendar();

    this.setupForm();

    this.dateForm.controls.selectedDate.valueChanges.subscribe((x) => {
      this.showEventsList();
    })
  }

  public dateForm!: FormGroup;

  public isEventsListVisible = false;

  options: NativeGeocoderOptions = {
    useLocale: true,
    maxResults: 5
  };

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService,
              private nativeGeocoder: NativeGeocoder) { }

  public async ngOnInit() {
    if(!navigator.geolocation){
      console.log('location is not supported');
    }

    navigator.geolocation.getCurrentPosition(position => {
      /*let loc = this.getReverseGeocodingData(position.coords.latitude, position.coords.longitude);*/
      console.log(position);
    });

    this.nativeGeocoder.reverseGeocode(52.5072095, 13.1452818, this.options)
      .then((result: NativeGeocoderResult[]) => console.log(JSON.stringify(result[0])))
      .catch((error: any) => console.log(error));
  }

  public setupForm() {
    this.dateForm = new FormGroup({
      'selectedDate': new FormControl()
    });
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
  }

  public setupCalendar() {
    const daysConfig = new Array<DayConfig>();
    this.events.forEach(event => {
      daysConfig.push({
        date: event.startingTime,
        cssClass: 'circled'
      })
    })

    this.calendarConfig = {
      showToggleButtons: true,
      showMonthPicker: true,
      from: new Date(1),
      daysConfig: daysConfig
    }
  }

  public async showEventsList() {
    if(this.calendarConfig.daysConfig.find(x => x.date.toString().slice(0, 10) === this.dateForm.controls.selectedDate.value)) {
      this.isEventsListVisible = true;

      if (this.content.scrollToBottom) {
        await this.content.scrollToBottom(300);
      }
    }
  }
}
