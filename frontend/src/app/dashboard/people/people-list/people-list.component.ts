import { Component, EventEmitter, OnInit } from '@angular/core';
import {PersonModel} from "../../common/models/person.model";
import {PeopleService} from "../../common/services/people.service";
import {IonRouterOutlet, ModalController} from "@ionic/angular";
import {PeopleAddComponent} from "../people-add/people-add.component";
import {Gender} from "../../common/enums/gender.enum";
import {Person} from "@angular/cli/utilities/package-json";

@Component({
  selector: 'app-people',
  templateUrl: './people-list.component.html',
  styleUrls: ['./people-list.component.scss'],
})
export class PeopleListComponent implements OnInit {
  public people: Array<PersonModel>;

  public closeModalEmitter = new EventEmitter();

  constructor(private peopleService: PeopleService,
              private modalController: ModalController) { }

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

  public async deletePerson(personId: string) {
    await this.peopleService.deletePerson(personId);
  }

  public handleCloseModalEvent() {
    this.closeModalEmitter.subscribe(async () => {
      this.modalController.dismiss({
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
