import {AfterViewInit, Component, ElementRef, Input, OnChanges, ViewChild} from '@angular/core';
import {EventActionModel, EventModel} from '../../common/models/event.model';
import {EventsService} from '../../common/services/events.service';
import SwiperCore, {EffectCoverflow, Pagination} from 'swiper';
import {AlertController, AnimationController} from '@ionic/angular';
import {EventStatus} from '../../common/enums/event-status.enum';

SwiperCore.use([EffectCoverflow, Pagination]);

@Component({
  selector: 'app-events-list',
  templateUrl: './events-list.component.html',
  styleUrls: ['./events-list.component.scss'],
})

export class EventsListComponent implements OnChanges, AfterViewInit {
  @ViewChild('button', { read: ElementRef, static: true })
  public button: ElementRef;

  @Input()
  public eventsDate: Date;

  public events: Array<EventModel>;

  constructor(private eventService: EventsService,
              private animationController: AnimationController,
              private alertController: AlertController) {}

  public async ngAfterViewInit() {
    await this.animateButton();
  }

  public async ionViewWillEnter() {
    await this.loadEvents();
  }

  public async ngOnChanges() {
    await this.loadEvents();
  }

  public async deleteEvent(eventId: string) {
    await this.eventService.deleteEvent(eventId);
    await this.loadEvents();
  }

  public async updateEvent(eventActionModel: EventActionModel) {
    if(eventActionModel.actionType === 'Start' && this.events.filter(x => x.status === EventStatus.InProgress).length > 1) {
      const alert = await this.alertController.create({
        cssClass: 'my-custom-class',
        header: 'Alert',
        message: 'You cannot start this event, as you have another one in progress.',
        buttons: [{
            text: 'Cancel'
          }]
      });

      await alert.present();
    } else if(eventActionModel.actionType === 'End') {
      await this.eventService.updateEvent(eventActionModel.eventModel);
      await this.loadEvents();
    }
  }

  private async loadEvents() {
    this.events = await this.eventService.getEventsByDate(this.eventsDate);
  }

  private async animateButton() {
    const animation = this.animationController
      .create()
      .addElement(this.button.nativeElement)
      .duration(3000)
      .iterations(Infinity)
      .fromTo('transform', 'translateX(0)', 'translateX(100%)');

    await animation.play();
  }
}
