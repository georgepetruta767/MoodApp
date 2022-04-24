import {Component, OnInit} from '@angular/core';
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {NativeGeocoder, NativeGeocoderOptions, NativeGeocoderResult} from "@ionic-native/native-geocoder/ngx";
import {FormControl, FormGroup} from "@angular/forms";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})
export class PlannerComponent implements OnInit {
  public async ionViewWillEnter(){
    await this.loadEvents();

    this.setupForm();
  }

  public dateForm: FormGroup;

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
      'selectedDate': new FormControl('')
    });
  }

  public getMonths() {
    return [...new Set(this.events.map(x => new Date(x.startingTime).getMonth() + 1))];
  }

  public getYears() {
    return [...new Set(this.events.map(x => new Date(x.startingTime).getFullYear()))];
  }

  public getDays() {
    return [...new Set(this.events.map(x => new Date(x.startingTime).getDate()))];
  }

  public async loadEvents() {
    this.events = await this.eventsService.getEvents();
  }

  public async openEventPopover() {
    this.isEventsListVisible = true;
  }
}
