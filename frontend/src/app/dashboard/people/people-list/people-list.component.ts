import { Component, EventEmitter, OnInit } from '@angular/core';
import {PersonModel} from "../../common/models/person.model";
import {PeopleService} from "../../common/services/people.service";
import {AlertController, ModalController} from "@ionic/angular";
import {PeopleAddComponent} from "../people-add/people-add.component";
import {Gender} from "../../common/enums/gender.enum";

@Component({
  selector: 'app-people',
  templateUrl: './people-list.component.html',
  styleUrls: ['./people-list.component.scss'],
})
export class PeopleListComponent implements OnInit {
  public people: Array<PersonModel>;

  public searchTerm: string;

  public closeModalEmitter = new EventEmitter();

  constructor(private peopleService: PeopleService,
              private modalController: ModalController,
              private alertController: AlertController) { }

  public async ngOnInit() {
    await this.loadPeople();

    this.handleCloseModalEvent();
  }

  public async presentModal(person?: PersonModel) {
    const modal = await this.modalController.create({
      component: PeopleAddComponent,
      breakpoints: [0.3, 0.5, 0.8, 1],
      initialBreakpoint: 0.9,
      componentProps: {
        closeModalEvent: this.closeModalEmitter,
        personToEdit: person ? person: null
      }
    });
    return await modal.present();
  }

  public async deletePerson(person: PersonModel) {
    const alert = await this.alertController.create({
      cssClass: 'my-custom-class',
      header: 'Alert',
      message: `Are you sure you want to delete ${person.firstName} ${person.lastName}?`,
      buttons: [{
        text: 'Delete',
        handler: async () => {
          await this.peopleService.deletePerson(person.id);
        }
      },
        'Cancel']
    });

    await alert.present();
  }

  public handleCloseModalEvent() {
    this.closeModalEmitter.subscribe(async () => {
      await this.modalController.dismiss({
        'dismissed': true
      });
      await this.loadPeople();
    })
  }

  private async loadPeople() {
    this.people = await this.peopleService.getPeople();
  }

  public getGenderLabel(gender: Gender) {
    return gender === Gender.Female ? 'Female' : 'Male';
  }

  public getFullName(person: PersonModel) {
    return `${person.firstName} ${person.lastName}`;
  }
}
