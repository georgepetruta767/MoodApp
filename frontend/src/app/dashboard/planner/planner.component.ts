import {Component, OnInit} from '@angular/core';
import {CalendarComponentOptions, CalendarDay, DayConfig} from "ion2-calendar";
import {EventModel} from "../common/models/event.model";
import {EventsService} from "../common/services/events.service";
import {PopoverController} from "@ionic/angular";
import {EventDetailsComponent} from "./event-details/event-details.component";
import {NativeGeocoder, NativeGeocoderOptions, NativeGeocoderResult} from "@ionic-native/native-geocoder/ngx";

@Component({
  selector: 'app-planner',
  templateUrl: './planner.component.html',
  styleUrls: ['./planner.component.scss']
})
export class PlannerComponent implements OnInit {
  public async ionViewWillEnter(){
    await this.loadEvents();

    this.setupCalendarConfig();
  }

  options: NativeGeocoderOptions = {
    useLocale: true,
    maxResults: 5
  };

  public calendarConfig!: CalendarComponentOptions;

  public events!: Array<EventModel>;

  constructor(private eventsService: EventsService,
              public popoverController: PopoverController,
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

  public setupCalendarConfig() {
    this.calendarConfig = {
      showMonthPicker: true,
      from: new Date(1),
      daysConfig: Array<DayConfig>()
    };

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

      await popover.present();

      return popover.onDidDismiss().then(
        async (data: any) => {
          if (data) {
            const handleEventModel = data.data;
            switch(handleEventModel.mode) {
              case "delete":
                await this.eventsService.deleteEvent(handleEventModel.eventId);
                break;
              case "update":
                await this.eventsService.updateEvent(handleEventModel.event);
                break;
              default:
                break;
            }
            await this.loadEvents();
          }
        }
      )
    }
  }
}
