import {Gender} from "../enums/gender.enum";

export class PersonModel {
  public id?: string;
  public firstName!: string;
  public lastName!: string;
  public age!: number;
  public gender!: Gender
}
