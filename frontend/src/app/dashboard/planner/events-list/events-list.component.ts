import {AfterViewInit, Component, ElementRef, Input, OnChanges, Output, ViewChild} from '@angular/core';
import {EventModel} from "../../common/models/event.model";
import {EventsService} from "../../common/services/events.service";
import SwiperCore, {EffectCoverflow, Pagination} from "swiper";
import {AnimationController} from "@ionic/angular";

SwiperCore.use([EffectCoverflow, Pagination]);

@Component({
  selector: 'app-events-list',
  templateUrl: './events-list.component.html',
  styleUrls: ['./events-list.component.scss'],
})

export class EventsListComponent implements OnChanges, AfterViewInit {
  public async ionViewWillEnter() {
    await this.loadEvents();
  }

  public async ngOnChanges() {
    await this.loadEvents();
  }

  @ViewChild("button", { read: ElementRef, static: true })
  button: ElementRef

  @Input()
  public eventsDate: Date;

  public events: Array<EventModel>;

  constructor(private eventService: EventsService,
              private animationController: AnimationController) {}

  public ngAfterViewInit() {
    this.animateButton()
  }

  public animateButton() {
    const animation = this.animationController
      .create()
      .addElement(this.button.nativeElement)
      .duration(3000)
      .iterations(Infinity)
      .fromTo('transform', 'translateX(0)', 'translateX(100%)')

    animation.play()
  }

  public async deleteEvent(eventId: string) {
    await this.eventService.deleteEvent(eventId);
    await this.loadEvents();
  }

  public async loadEvents() {
    this.events = await this.eventService.getEventsByDate(this.eventsDate);
  }
}
