import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {PeopleService} from "../../common/services/people.service";
import {PersonModel} from "../../common/models/person.model";

@Component({
  selector: 'app-people-edit',
  templateUrl: './people-edit.component.html',
  styleUrls: ['./people-edit.component.scss'],
})
export class PeopleEditComponent {
  public ionViewWillEnter() {
    this.setupForm();
  }

  @Output()
  public closeModalEvent = new EventEmitter<string>();

  @Input()
  public personToEdit: PersonModel;

  public form!: FormGroup;

  constructor(private peopleService: PeopleService) { }

  private setupForm() {
    this.form = new FormGroup({
      firstName: new FormControl(this.personToEdit ? this.personToEdit.firstName : '', [Validators.required]),
      lastName: new FormControl(this.personToEdit ? this.personToEdit.lastName : '', [Validators.required]),
      age: new FormControl(this.personToEdit ? this.personToEdit.age : '', [Validators.required, Validators.min(0), Validators.max(100)]),
      gender: new FormControl( this.personToEdit ? this.personToEdit.gender : '', [Validators.required]),
      socialStatus: new FormControl(this.personToEdit ? this.personToEdit.socialStatus : '', [Validators.required])
    });
  }

  public getPersonStatus() {
    return this.personToEdit.socialStatus;
  }

  public async onSubmit() {
    if(this.form.valid) {
      const personModel = {
        id: this.personToEdit ? this.personToEdit.id : undefined,
        firstName: this.form.controls.firstName.value,
        lastName: this.form.controls.lastName.value,
        age: this.form.controls.age.value,
        gender: Number(this.form.controls.gender.value),
        socialStatus: Number(this.form.controls.socialStatus.value)
      };

      this.personToEdit ? await this.peopleService.updatePerson(personModel) : await this.peopleService.addPerson(personModel);

      this.emitCloseModalEvent();
    }
  }

  public emitCloseModalEvent() {
    this.closeModalEvent.emit();
  }

  public getActionLabel() {
    return this.personToEdit ? 'Save' : 'Add';
  }

  public getCorrectHeaderTitle() {
    return this.personToEdit ? `${this.personToEdit.firstName} ${this.personToEdit.lastName}` : 'Add a new person';
  }
}
